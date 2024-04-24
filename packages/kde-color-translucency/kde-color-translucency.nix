{
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  libepoxy,
  libxcb,
  lib,
}:

# Plasma 6
stdenv.mkDerivation {
  pname = "kde-color-Translucency";
  version = "2024-04-08";

  src = fetchFromGitHub {
    owner = "aaronkirschen";
    repo = "KDE-Color-Translucency";
    rev = "73749a8d9d6f3def276110cb7246727ac4e00e4e";
    hash = "sha256-oFPGksT1LIYWOGYygMc2jMQZzrj58d1+fIYoBhuHqjw=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = [
    kdePackages.kwin
    kdePackages.kcmutils
    libepoxy
    libxcb
  ];

  meta = with lib; {
    description = "Renders a specific color as transparent within window content";
    homepage = "https://github.com/aaronkirschen/KDE-Color-Translucency";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flexagoon ];
  };
}
