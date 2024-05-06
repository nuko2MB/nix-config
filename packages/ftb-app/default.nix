{
  appimageTools,
  fetchurl,
  jdk8,
  jdk17,
  jdks ? [
    jdk8
    jdk17
  ],
}:
# Wrapping the appimage because nixpkgs pnpm support is ...no fun 
let
  pname = "ftb-app";
  version = "1.25.8";
  src = fetchurl {
    url = "https://piston.feed-the-beast.com/app/ftb-app-${version}-x86_64.AppImage";
    sha256 = "sha256-PqbfIOTHhfMX5aymafom73LTgedYtmf+w6seAq24ZM8=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs = pkgs: jdks;
}
