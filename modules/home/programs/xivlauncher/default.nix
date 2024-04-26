{
  lib,
  pkgs,
  config,
  ...
}@args:
lib.nuko.mkModule args
  [
    "programs"
    "xivlauncher"
  ]
  {
    home.packages = with pkgs; [ xivlauncher ];

    home.file.".xlcore/xiv-wine-wayland".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nuko.xiv-wine-wayland}/share/xiv-wine-wayland";
  }
