{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkOption mkIf foldl';
  inherit (lib.types) str listOf;
  cfg = config.wayland.windowManager.hyprland;
in
{
  options.wayland.windowManager.hyprland = {
    gameRules = mkOption {
      type = listOf str;
      default = [
        "workspace 3"
        "immediate"
      ];
    };
    games = mkOption {
      type = listOf str;
      default = [ ];
    };
  };

  config.wayland.windowManager.hyprland.settings.windowrulev2 =
    let

      applyRules = game: map (rule: rule + ", ${game}") cfg.gameRules;
      mkRules = foldl' (acc: game: (acc ++ (applyRules game))) [ ];
    in
    mkIf (cfg.games != [ ]) (mkRules cfg.games);
}
