{ lib, ... }:
let
  inherit (lib)
    nameValuePair
    listToAttrs
    range
    mapAttrsToList
    foldlAttrs
    ;

  #Helper Functions to create hyprland binds

  # Create the string value for the key bind
  mkBind =
    mod2: key: action:
    if mod2 == "none" then "$mod," + key + "," + action else "$mod ${mod2}," + key + "," + action;

  # Converts a attrset of binds into a list of binds.
  mkBindList = mod2: mapAttrsToList (key: action: mkBind mod2 key action);

  # Create binds from an attrset where the toplevel is secondary modifiers.
  mkBinds = foldlAttrs (
    acc: mod2: cfg:
    acc ++ (mkBindList mod2 cfg)
  ) [ ];

  # Auto Generate binds for workspaces. Meta 1-9 and meta shift 1-9
  createWorkspaceBindsRaw =
    mod2: action:
    mkBindList mod2 (
      listToAttrs (map (index: nameValuePair index "${action}, ${index}") (map toString (range 1 9)))
    );

  mkWorkspaceBinds = createWorkspaceBindsRaw "none" "workspace";
  mkMoveBinds = createWorkspaceBindsRaw "SHIFT" "movetoworkspace";

  # Helper function to combine the above functions.
  mkBindCfg = binds: mkWorkspaceBinds ++ mkMoveBinds ++ (mkBinds binds);
in
{
  hypr = {
    inherit mkBindCfg;
  };
}
