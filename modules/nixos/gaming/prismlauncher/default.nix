{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "gaming"
    "prismlauncher"
  ]
  {
    # Prismlauncher is overlayed with extra jdk's
    environment.systemPackages = [ pkgs.prismlauncher ];
  }
