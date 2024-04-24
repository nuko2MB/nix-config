{
  pkgs,
  lib,
  inputs,
  ...
}@args:
let
  nix-vscode = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  ext-pinned = nix-vscode.vscode-marketplace-release;
  ext-nightly = nix-vscode.vscode-marketplace;
  ext-nixpkgs = pkgs.vscode-extensions;
in
lib.nuko.mkModule args
  [
    "programs"
    "vscode"
  ]
  {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      extensions =
        with ext-nightly;
        [
          jnoortheen.nix-ide
          catppuccin.catppuccin-vsc
          tamasfe.even-better-toml
          mkhl.direnv
          bmalehorn.vscode-fish
          thenuprojectcontributors.vscode-nushell-lang
          usernamehw.errorlens
        ]
        # Release pinned extensions
        ++ (with ext-pinned; [ rust-lang.rust-analyzer ]);
      userSettings = {
        "window.titleBarStyle" = "custom";
        "editor.fontSize" = lib.mkDefault 16;
        "workbench.colorTheme" = lib.mkDefault "Default Dark Modern";
        "explorer.autoReveal" = false;
        "editor.fontLigatures" = true;
        "editor.fontFamily" = lib.mkDefault "'Monaspace Neon','JetBrainsMono Nerd Font','Droid Sans Mono', 'monospace', monospace";
        "editor.formatOnSave" = true;
        #"nix.formatterPath" = "nixfmt";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          nil = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };

        # Error Lens
        errorLens = {
          onSave = true;
          enabledDiagnosticLevels = [ "error" ];
          gutterIconsEnabled = true;
          gutterIconSet = "defaultOutline";
        };
      };
    };
  }
