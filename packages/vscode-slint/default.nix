{
  lib,
  stdenv,
  vscode-utils,
  slint-lsp,
}:
let
  # Version needs to be kept in sync with nix-lsp to function properly
  version = "1.5.1";
in
assert slint-lsp.version == version;

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "Slint";
    publisher = "slint";
    inherit version;
    sha256 = "sha256-9NbSqINJXuv4xIIdhwkqVP8CgVURj0I4roUwPJ6zte0=";
  };

  platforms = [
    "x86_64-linux"
    "armv7l-linux"
    "aarch64-linux"
  ];
  patches = [ ];

  postInstall =
    let
      lookup = {
        "x86_64-linux" = "slint-lsp-x86_64-unknown-linux-gnu";
        "armv7l-linux" = "slint-lsp-armv7-unknown-linux-gnueabihf";
        "aarch64-linux" = "slint-lsp-aarch64-unknown-linux-gnu";
        "x86_64-darwin" = "Slint Live Preview.app";
      };
      lsp-path = "$out/share/vscode/extensions/slint.Slint/bin/${lookup.${stdenv.system}}";
    in
    ''
      rm -r ${lsp-path}
      ln -sf ${lib.getExe slint-lsp} ${lsp-path}
    '';

  meta = {
    description = "This extension for VS Code adds support for the Slint design markup language.";
    homepage = "https://marketplace.visualstudio.com/items?itemName=Slint.slint";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
