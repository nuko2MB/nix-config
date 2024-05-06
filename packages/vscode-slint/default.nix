{
  lib,
  stdenv,
  vscode-utils,
  lua-language-server,
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
      binary =
        if stdenv.system == "x86_64-linux" then
          "slint-lsp-x86_64-unknown-linux-gnu"
        else if stdenv.system == "armv7l-linux" then
          "slint-lsp-armv7-unknown-linux-gnueabihf"
        else if stdenv.system == "aarch64-linux" then
          "slint-lsp-aarch64-unknown-linux-gnu"
        else
          # Does this even work? Idk anything about darwin 
          "Slint Live Preview.app";
      lsp-path = "$out/share/vscode/extensions/slint.Slint/bin/${binary}";
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
