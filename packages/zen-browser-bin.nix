{ stdenvNoCC, fetchurl, undmg }:

stdenvNoCC.mkDerivation rec {
  pname = "zen-browser";
  version = "1.17.15b";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.macos-universal.dmg";
    hash = "sha256-Lv7K5782E2ci5rtRA3SQpkZ+kVdOgYhD2Lc+L+gyFtA=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    runHook preUnpack
    undmg "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"

    # Найдём .app внутри распакованного dmg (на случай, если имя/папки меняются)
    app="$(find . -maxdepth 2 -type d -name '*.app' -print -quit)"
    if [ -z "$app" ]; then
      echo "ERROR: .app not found after undmg"
      find . -maxdepth 3 -print
      exit 1
    fi

    cp -R "$app" "$out/Applications/"
    runHook postInstall
  '';
}
