{ pkgs, ... }: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # Удалять всё, что не описано в этом конфиге
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
	
    # 1. CASKS — Приложения с графическим интерфейсом (.app)
    casks = [
      "zen"
      "docker-desktop"
      "steam"
      # "porting-kit" # НЕНАДО ДЯДЯ
      "pearcleaner"
      "blender"
      "libreoffice"
      "libreoffice-language-pack"
      "obs"
      "blackhole-2ch"
    ];

	  # 2. BREWS — Консольные утилиты, которых нет в Nix или которые нужны именно из Brew
    brews = [
      "yt-dlp" # "mpv"
      "mas" # позволяет находить ID из официального Mac App Store
      "tt" # tarantool утилита
      # "go@1.24"
    ];

	  # 3. MASAPPS — Приложения из официального Mac App Store (если нужно, по ID) (требуется "mas")
	  masApps = { 
	    # "Xcode" = 497799835; 
	  };

	  # 4. TAPS — Дополнительные сторонние репозитории (формулы) 
	  # Если приложение требует сначала выполнить 'brew tap ...'
	  taps = [

  	];	  
 	};
}
