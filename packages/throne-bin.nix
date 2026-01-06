{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "throne";
  version = "1.0.12";

  src = fetchzip {
    url = "github.com/throneproj/Throne/releases/download/${version}/Throne-${version}-macos-arm64.zip";
    hash = "sha256-rUFdWBaLA3iYgr5GWkBXf5IzWIbXJHdShRne4DTguRA=";
    stripRoot = false;
  };

  dontBuild = true;
  dontPatch = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p "$out/Applications"

    app="$(find . -maxdepth 3 -type d -name '*.app' -print -quit)"
    if [ -z "$app" ]; then
      echo "ERROR: .app bundle not found in archive"
      echo "Archive содержимое:"
      find . -maxdepth 3 -print
      exit 1
    fi

    echo "Found app: $app"
    cp -R "$app" "$out/Applications/"
  '';
}
