{ lib, pkgs, ... }:
with lib.nuko;
{
  imports = [ ./hardware-configuration.nix ];
  nuko = {
    boot = enabled;
    sound = {
      enable = true;
      lowLatency = enabled;
    };
    filesystem.btrfs = {
      enable = true;
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_2000GB_2328598";
    };
    greetd = enabled;

    gaming = {
      enable = true;
      steam = enabled;
      prismlauncher = enabled;
      sunshine = enabled;
    };

    desktop = {
      xdg-portal = enabled;
      fonts = enabled;
    };

    services = {
      gnome-keyring = enabled;
      kanata = enabled;
      samba = {
        enable = true;
        paths = [ "/srv/share" ];
      };
    };

    programs = {
      cli = enabled;
      # nemo = enabled;
    };

    intel.hw-accel = enabled;

    nix = {
      enable = true;
      extra-substituters = {
        "https://cosmic.cachix.org/".key = "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=";
      };
    };
  };

  services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;
  #services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_CA.UTF-8";

  networking = {
    hostName = "kagebi";
    networkmanager.enable = true;
  };

  programs = {
    hyprland.enable = true;
    dconf.enable = true;
  };

  # FFXIV XL OTP APP
  networking.firewall = {
    allowedTCPPorts = [ 4646 ];
    allowedUDPPorts = [ 4646 ];
  };

  #security.pam.services.swaylock = { };
  security.pam.services.hyprlock = { };

  environment.systemPackages = with pkgs; [
    #General
    firefox
    spotify
    nuko.wallpapers
    qbittorrent
    discord
    stremio
    yt-dlp
    google-chrome

    # Dev Tools
    cage
    git
    lapce
    nil
    gh
    statix

    # Other
    xdg-utils
    umu

    # Games
    protontricks
    lutris
    nuko.wowup-cf
    nuko.ftb-app
    # nuko.kde-color-translucency
    # bottles

    # Harware
    libva
    libva-utils
  ];

  system.stateVersion = "23.11";
}
