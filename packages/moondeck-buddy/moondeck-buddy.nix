{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,
  ninja,
  cmake,
  wrapQtAppsHook,
  procps,
  xorg,
  fuse,
  xcb-util-cursor,
  steam,
}:
let
  pname = "moondeck-buddy";
  version = "1.6.1";
  src = fetchFromGitHub {
    owner = "FrogTheFrog";
    repo = "moondeck-buddy";
    rev = "v${version}";
    sha256 = "sha256-1YprssMx97svStKM+6WWLWKt+/CRxf//uC8oRZO//Cs=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation {
  inherit pname version src;
  nativeBuildInputs = [
    ninja
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qthttpserver
    xorg.libXrandr
    procps
    steam
    # Copied from upstream github actions build:
    qt6.qtwebsockets
    fuse
    xcb-util-cursor
  ];

  postPatch = ''
    substituteInPlace src/lib/os/linux/steamregistryobserver.cpp \
        --replace-fail /usr/bin/steam ${lib.getExe steam};
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=Release"
    "-G Ninja"
  ];
}
