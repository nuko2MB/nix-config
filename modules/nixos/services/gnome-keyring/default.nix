{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "services"
    "gnome-keyring"
  ]
  {
    # The nixos module does not have a components option in order to start with ssh support.
    nuko.home.extraOptions = {
      services.gnome-keyring = {
        enable = true;
        components = [
          "secrets"
          "ssh"
        ];
      };
    };
    services.gnome.gnome-keyring.enable = true;
    environment.variables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };

    security.pam.services.greetd.enableGnomeKeyring = true;
    programs.seahorse.enable = true;
  }
