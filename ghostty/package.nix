{ lib
, stdenv
, fontconfig
, freetype
, harfbuzz
, oniguruma
, bzip2
, ncurses
, pandoc
, pkg-config
, removeReferencesTo
, versionCheckHook
, zig_0_14
, darwin
, ghosttySrc
}:

let
  zig = zig_0_14;
  zig_hook = zig.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=ReleaseFast --color off";
  };
in
stdenv.mkDerivation {
  pname = "ghostty";
  version = "git-${ghosttySrc.rev or "pinned"}";
  src = ghosttySrc;

  nativeBuildInputs = [
    ncurses pandoc pkg-config removeReferencesTo zig_hook
  ];

  buildInputs = [
    oniguruma bzip2 fontconfig freetype harfbuzz
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.Metal
    darwin.apple_sdk.frameworks.CoreText
  ];

  buildPhase = ''
    export HOME=$TMPDIR
    export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-global
    export ZIG_LOCAL_CACHE_DIR=$TMPDIR/zig-local

    zig build \
      -Dapp-runtime=cocoa \
      -Drenderer=metal \
      -Dfont-backend=coretext \
      -Dversion-string=${version}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp zig-out/bin/ghostty $out/bin/
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Ghostty terminal (darwin)";
    homepage = "https://ghostty.org/";
    license = lib.licenses.mit;
    mainProgram = "ghostty";
    platforms = lib.platforms.darwin;
  };
}
