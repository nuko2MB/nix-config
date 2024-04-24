# Low latency audio module. Forked from 'fufexan/nix-gaming'
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) int;
  inherit (lib.generators) toLua;

  cfg = config.nuko.sound.lowLatency;
  qr = "${toString cfg.quantum}/${toString cfg.rate}";
in
{
  options = {
    nuko.sound.lowLatency = {
      enable = mkEnableOption ''
        low latency for PipeWire. This will also set `services.pipewire.enable` and
        `services.pipewire.wireplumber.enable` to true.
      '';

      quantum = mkOption {
        description = "Minimum quantum to set";
        type = int;
        default = 64;
        example = 32;
      };

      rate = mkOption {
        description = "Rate to set";
        type = int;
        default = 48000;
        example = 96000;
      };
    };
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      # make sure PipeWire is enabled if the module is imported
      # and low latency is enabledd
      enable = true;

      # write extra config
      extraConfig.pipewire = {
        "99-lowlatency" = {
          context = {
            properties.default.clock.min-quantum = cfg.quantum;
            modules = [
              {
                name = "libpipewire-module-rtkit";
                flags = [
                  "ifexists"
                  "nofail"
                ];
                args = {
                  nice.level = -15;
                  rt = {
                    prio = 88;
                    time.soft = 200000;
                    time.hard = 200000;
                  };
                };
              }
              {
                name = "libpipewire-module-protocol-pulse";
                args = {
                  server.address = [ "unix:native" ];
                  pulse.min = {
                    req = qr;
                    quantum = qr;
                    frag = qr;
                  };
                };
              }
            ];

            stream.properties = {
              node.latency = qr;
              resample.quality = 1;
            };
          };
        };
      };

      # ensure WirePlumber is enabled explicitly (defaults to true while PW is enabled)
      wireplumber.enable = true;
    };
    # and write extra config to ship low latency rules for alsa
    # TODO: Migrate to nix option when the module is updated.
    # https://github.com/NixOS/nixpkgs/pull/292115
    nuko.home.configFile = {
      "wireplumber/wireplumber.conf.d/99-alsa-lowlatency.conf".text = ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                node.name = "~alsa_output.*""
              }
            ]
            actions = {
              update-props = {
                audio.format = "S32LE";
                audio.rate = ${toString (cfg.rate * 2)} ;
                api.alsa.period-size = 2;
              }
            }
          }
        ]
      '';
    };
  };
}
