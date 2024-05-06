{
  lib,
  config,
  inputs,
  pkgs,
  ...
}@args:
lib.nuko.mkModule args
  [
    "services"
    "hypridle"
  ]
  {
    nuko.desktop.hyprlock.enable = true;
    services.hypridle =
      let
        hyprlock = lib.getExe config.programs.hyprlock.package;
        hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
        systemctl = lib.getExe' pkgs.systemd "systemctl";
      in
      {
        enable = true;
        # TODO: systemctl lock should
        settings = {
          general = {
            lockCmd = "${hyprlock}";
            beforeSleepCmd = "${hyprlock}";
          };

          listeners = [
            {
              timeout = 500;
              onTimeout = "${hyprlock}";
            }
            {
              timeout = 900;
              onTimeout = "${hyprctl} dispatch dpms off";
              onResume = "${hyprctl} dispatch dpms on";
            }
            {
              timeout = 1200;
              onTimeout = "${systemctl} suspend";
            }
          ];
        };
      };
  }
