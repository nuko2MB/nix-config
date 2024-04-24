{
  lib,
  inputs,
  pkgs,
  ...
}@args:
lib.nuko.mkModule args
  [
    "gaming"
    "steam"
  ]
  {
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  }
