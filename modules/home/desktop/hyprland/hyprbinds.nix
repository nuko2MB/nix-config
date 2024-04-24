{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkIf
    singleton
    foldlAttrs
    ;
  inherit (lib.types)
    str
    coercedTo
    listOf
    attrsOf
    ;
  cfg = config.wayland.windowManager.hyprland;
in
{
  options.wayland.windowManager.hyprland.binds = mkOption {
    type = attrsOf (attrsOf (coercedTo str singleton (listOf str)));

    default = { };
  };
  config.wayland.windowManager.hyprland.settings.bind =
    let
      # Create a list of binds from an list of actions
      mkBind =
        mod2: key:
        if mod2 == "none" then
          map (action: "$mod," + key + "," + action)
        else
          map (action: "$mod ${mod2}," + key + "," + action);

      # Create binds from an attrset where the index is the "key".
      mkBindsFromKey =
        mod2:
        foldlAttrs (
          acc: key: actions:
          acc ++ (mkBind mod2 key actions)
        ) [ ];

      # Create binds from an attrset where the index is a secondary modifier.
      mkBindsFromMod = foldlAttrs (
        acc: mod2: cfg:
        acc ++ (mkBindsFromKey mod2 cfg)
      ) [ ];
    in
    mkIf (cfg.binds != { }) (mkBindsFromMod cfg.binds);
}
