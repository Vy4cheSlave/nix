{ lib
, stdenv
, fetchurl
, fetchzip
, unzip ? null
, makeWrapper ? null
, autoPatchelfHook ? null
, appimageTools ? null
}:

let
  pname = "yourapp";
  version = "1.0.0";

  isDarwin = stdenv.hostPlatform.isDarwin;
  isLinux  = stdenv.hostPlatform.isLinux;

  # 1) Выбираем "тип" релиза под платформу:
  #    - darwinZip: zip c .app
  #    - linuxAppImage: AppImage
  #    - linuxTar: tar.gz/zip с бинарём
  #    Поменяй ровно один вариант под твой проект.
  releaseKind =
    if isDarwin then "darwinZip"
    else if isLinux then "linuxAppImage"
    else throw "Unsupported platform: ${stdenv.hostPlatform.system}";

  # 2) URL и hash под каждую платформу.
  #    Вставляй реальные ссылки и хеши.
  darwin = {
    url  = "https://example.com/${pname}-${version}-macos-arm64.zip";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  linux = {
    # Вариант AppImage:
    appImageUrl  = "https://example.com/${pname}-${version}-linux-x86_64.AppImage";
    appImageHash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";

    # Вариант tarball (если не AppImage):
    tarUrl  = "https://example.com/${pname}-${version}-linux-x86_64.tar.gz";
    tarHash = "sha256-CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC=";
  };

  # 3) Источник (src) под выбранный релиз.
  src =
    if releaseKind == "darwinZip" then
      fetchzip {
        url = darwin.url;
        hash = darwin.hash;
        stripRoot = false;
      }
    else if releaseKind == "linuxAppImage" then
      fetchurl {
        url = linux.appImageUrl;
        hash = linux.appImageHash;
      }
    else
      fetchzip {
        url = linux.tarUrl;
        hash = linux.tarHash;
        stripRoot = false;
      };

in
stdenv.mkDerivation {
  inherit pname version src;

  # Для бинарных релизов обычно сборки нет.
  dontConfigure = true;
  dontBuild = true;

  # Нативные инпуты нужны только когда реально используются.
  nativeBuildInputs =
    lib.optionals isDarwin [ ] ++
    lib.optionals isLinux (
      lib.optionals (releaseKind == "linuxAppImage") [ appimageTools makeWrapper ] ++
      lib.optionals (releaseKind != "linuxAppImage") [ autoPatchelfHook ]
    );

  # Если на Linux бинарь динамический, autoPatchelfHook поможет.
  # buildInputs = [ ...libraries... ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share"

    if [ "${releaseKind}" = "darwinZip" ]; then
      # ---- macOS: ищем .app и ставим в $out/Applications + создаём лаунчер ----
      mkdir -p "$out/Applications"

      appPath="$(find . -maxdepth 10 -type d -name '*.app' -print -quit)"
      if [ -z "$appPath" ]; then
        echo "ERROR: .app bundle not found"
        echo "Tree (depth 4):"
        find . -maxdepth 4 -print
        exit 1
      fi

      # Выбираем название .app
      appName="$(basename "$appPath")"
      cp -R "$appPath" "$out/Applications/$appName"

      # CLI-лаунчер (удобно для Raycast/Terminal)
      cat > "$out/bin/${pname}" <<EOF
#!/usr/bin/env bash
set -euo pipefail
open -a "\$(
  cd "\$(dirname "\$0")/.."
  pwd
)/Applications/$appName"
EOF
      chmod +x "$out/bin/${pname}"

    elif [ "${releaseKind}" = "linuxAppImage" ]; then
      # ---- Linux: AppImage -> распаковать и сделать wrapper ----
      # Требует appimageTools.
      mkdir -p "$out/opt/${pname}"

      # appimageTools умеет это лучше, но тут "универсально" в bash:
      # скопируем AppImage как есть и завернём запуск
      cp "$src" "$out/opt/${pname}/${pname}.AppImage"
      chmod +x "$out/opt/${pname}/${pname}.AppImage"

      cat > "$out/bin/${pname}" <<EOF
#!/usr/bin/env bash
set -euo pipefail
exec "$out/opt/${pname}/${pname}.AppImage" "\$@"
EOF
      chmod +x "$out/bin/${pname}"

    else
      # ---- Linux: tar/zip -> найти бинарь и поставить в $out/bin ----
      # Настрой "что считать бинарём": имя файла, путь, etc.
      binPath="$(find . -maxdepth 10 -type f -name '${pname}' -print -quit)"
      if [ -z "$binPath" ]; then
        echo "ERROR: binary '${pname}' not found in archive"
        echo "Tree (depth 4):"
        find . -maxdepth 4 -print
        exit 1
      fi

      install -m 0755 "$binPath" "$out/bin/${pname}"
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Universal cross-platform package template (macOS + Linux)";
    homepage = "https://example.com";
    license = licenses.unfreeRedistributable; # поменяй под проект
    platforms = platforms.darwin ++ platforms.linux;
    # mainProgram = pname; # если хочешь
  };
}


{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:

stdenv.mkDerivation rec {
  pname = "yourapp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "OWNER";
    repo  = "REPO";
    rev   = "v${version}"; # или конкретный commit
    hash  = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  installPhase = ''
    runHook preInstall
    cmake --install . --prefix "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimal CMake source build template";
    homepage = "https://github.com/OWNER/REPO";
    license = licenses.mit; # поменяй
    platforms = platforms.darwin ++ platforms.linux;
  };
}
