{
  stdenv,
  fetchurl,
  lib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "xiv-wine-wayland";
  version = "9.6";

  src = fetchurl {
    url = "https://github.com/rankynbass/unofficial-wine-xiv-git/releases/download/v${version}/unofficial-wine-xiv-wayland-${version}.tar.zst";
    sha256 = "sha256-6AdcVp26Dui/0odyb7BFCbKjPKQJII3POxfgDpkxZdQ=";
  };

  nativeBuildInputs = [ zstd ];

  installPhase = ''
    mkdir -p "$out/share/${pname}"
    tar -xf $src -C "$out/share/${pname}" --strip-components=1
  '';

  meta = with lib; {
    description = "Wine build with wayland enabled and patches for FFXIV";
    homepage = "https://github.com/rankynbass/unofficial-wine-xiv-git";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
