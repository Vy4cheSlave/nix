{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "throne";
  version = "1.0.12";

  src = fetchzip {
    url = "github.com{version}/Throne-${version}-macos-arm64.zip";
    hash = "sha256-rUFdWBaLA3iYgr5GWkBXf5IzWIbXJHdShRne4DTguRA=";
    stripRoot = false;
  };

  dontBuild = true;
  dontPatch = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/Applications
    cp -R *.app $out/Applications/
  '';
}
