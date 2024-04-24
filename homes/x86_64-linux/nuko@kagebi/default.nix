{
  lib,
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}:
with lib.nuko;
{
  nuko = {
    desktop = {
      hyprland = enabled;
    };
    programs = {
      xivlauncher = enabled;
      vscode = enabled;
      foot = enabled;
      obs = enabled;
      git = enabled;
      fish = enabled;
    };
  };

  home.sessionVariables = {
    TERMINAL = "foot";
    EDITOR = "hx";
    NIXOS_OZONE_WL = "1"; # vscode wayland https://github.com/microsoft/vscode/issues/184124
  };

  programs = {
    zoxide = enabled;
    starship = enabled;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    mangohud = {
      enable = true;
      enableSessionWide = false;
      settings = {
        fps_only = 1;
        fps_limit = 168;
      };
      settingsPerApplication = {
        wine-Gw2-64 = {
          fps_only = 1;
          fps_limit = 168;
        };
        wine-DOOMx64vk = {
          fps_only = 1;
          fps_limit = 168;
        };
      };
    };

    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        thumbfast
        uosc
        autoload
        mpris
      ];
    };

    helix = {
      enable = true;
      defaultEditor = true;
    };
  };

  systemd.user.startServices = "sd-switch";
}
