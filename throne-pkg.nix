{ stdenv, fetchzip, lib }:

stdenv.mkDerivation rec {
  pname = "throne";
  version = "1.0.12";

  src = fetchzip {
    url = "https://github.com/throneproj/Throne/releases/download/${version}/Throne-${version}-macos-arm64.zip";
    hash = "sha256-rUFdWBaLA3iYgr5GWkBXf5IzWIbXJHdShRne4DTguRA=";
    stripRoot = false;
  };

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"

    # Найдём Throne.app где угодно внутри распакованного src
    appPath="$(find . -maxdepth 8 -type d -name 'Throne.app' -print -quit)"
    if [ -z "$appPath" ]; then
      echo "ERROR: Throne.app not found in source tree"
      echo "Top-level contents:"
      ls -la
      echo "Tree (depth 4):"
      find . -maxdepth 4 -print
      exit 1
    fi

    cp -R "$appPath" "$out/Applications/Throne.app"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Throne cross-platform GUI proxy utility (macOS .app bundle)";
    homepage = "https://github.com/throneproj/Throne";
    license = licenses.gpl3Only;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}