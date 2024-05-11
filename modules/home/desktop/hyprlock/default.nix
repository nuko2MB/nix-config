{
  lib,
  inputs,
  osConfig,
  ...
}@args:
lib.nuko.mkModule args
  [
    "desktop"
    "hyprlock"
  ]
  {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 30;
          hide_cursor = false;
        };
        background = [
          {
            inherit (osConfig.nuko.theme.wallpaper) path;
            blur_size = 4;
            blur_passes = 2;
          }
        ];
      };
    };
  }
