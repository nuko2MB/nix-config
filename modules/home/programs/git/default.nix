{
  lib,
  config,
  osConfig,
  ...
}@args:
with lib.nuko;
lib.nuko.mkModule args
  [
    "programs"
    "git"
  ]
  {
    # Add public ssh key so git will sign commits with it.
    home.file.".ssh/allowed_signers".text = ''git@nuko.boo namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPw/zwRS5ED6xbo79k98Rf+LUMKfbbUN0kzPrSsBZwBn'';
    programs = {
      # Git
      git = {
        enable = true;
        userEmail = "git@nuko.boo";
        signing = {
          signByDefault = true;
          key = "~/.ssh/id_ed25519_signing.pub";
        };
        extraConfig = {
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };
      lazygit = enabled;
      gh.enable = true;
    };
  }
