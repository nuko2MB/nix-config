{
  lib,
  pkgs,
  inputs,
  ...
}@args:
lib.nuko.mkModule args "sound" {
  hardware.pulseaudio.enable = lib.mkForce false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # TODO: Migrate to nix option when the module is updated.
  # https://github.com/NixOS/nixpkgs/pull/292115
  nuko.home.configFile = {
    # Use soft mixer because of issues with absolute volume.
    "wireplumber/wireplumber.conf.d/51-volume-fix.conf".text = ''
      monitor.alsa.rules = [
        {
          matches = [
            {
              device.name = "~alsa_card.*"
            }
          ]
          actions = {
            update-props = {
             api.alsa.soft-mixer = true
            }
          }
        }
      ]
    '';
    # Bug fix where auido stops working with multiple streams.
    # https://wiki.archlinux.org/title/PipeWire#Audio_cutting_out_when_multiple_streams_start_playing
    "wireplumber/wireplumber.conf.d/50-alsa-config.conf".text = ''
      monitor.alsa.rules = [
        {
          matches = [
            {
              # Matches all sources
              node.name = "~alsa_input.*"
            },
            {
              # Matches all sinks
              node.name = "~alsa_output.*"
            }
          ]
          actions = {
            update-props = {
              api.alsa.headroom = 1024
            }
          }
        }
      ]

    '';
  };
  security.rtkit.enable = true;

  # Bug fix where auido stops working with multiple streams.
  # https://wiki.archlinux.org/title/PipeWire#Audio_cutting_out_when_multiple_streams_start_playing
  /*
      # TODO: Still needed?
      # Sound does not automatically switch when connecting a new device
      "pipewire/pipewire-pulse.conf.d/switch-on-connect.conf".text = ''
        # override for pipewire-pulse.conf file
        pulse.cmd = [
            { cmd = "load-module" args = "module-always-sink" flags = [ ] }
            { cmd = "load-module" args = "module-switch-on-connect" }
        ]
      '';
    };
  */

  # Udev rule to disable hardware volume control.
  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="1377", ATTR{idProduct}=="6004", RUN+="/bin/sh -c 'echo 0 > /sys$DEVPATH/`basename $DEVPATH`:1.2/authorized'"
  '';
}
