{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.nuko;
let
  cfg = config.nuko.user;
in
{
  options.nuko.user = with types; {
    name = mkOpt str "nuko" "The name to use for the user account.";
    email = mkOpt str "git@nuko.boo" "The email of the user.";
    initialPassword =
      mkOpt str "password"
        "The initial password to use when the user is first created.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { } (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    programs.fish.enable = lib.mkDefault true;

    users.users.${cfg.name} = {
      isNormalUser = true;

      inherit (cfg) name initialPassword;

      home = "/home/${cfg.name}";
      group = "users";

      shell = lib.mkOverride 600 pkgs.fish;

      # Arbitrary user ID to use for the user. Since I only
      # have a single user on my machines this won't ever collide.
      # However, if you add multiple users you'll need to change this
      # so each user has their own unique uid (or leave it out for the
      # system to select).
      uid = 1000;

      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
