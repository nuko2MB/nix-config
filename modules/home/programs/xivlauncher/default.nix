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
  # gamescope -w 2560 -h 1440 -W 2560 -H 1440 --expose-wayland  -r 170 --adaptive-sync --immediate-flips --force-grab-cursor -b  -- XIVLauncher.Core
  {
    home.packages = with pkgs; [ xivlauncher ];

    home.file.".xlcore/xiv-wine-wayland".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nuko.xiv-wine-wayland}/share/xiv-wine-wayland";
  }
