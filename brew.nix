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
      # "blender" # хуйня нестабильная
      "libreoffice" # этот вроде рабочий
      # "libreoffice-language-pack"
      "obs"
      "blackhole-2ch"
      "handbrake-app"
      "kdenlive"
      "openmtp"
      "gimp"
    ];

	  # 2. BREWS — Консольные утилиты, которых нет в Nix или которые нужны именно из Brew
    brews = [
      "yt-dlp" # "mpv" для скачивания видео с ютуба (вроде требуется ffmpeg)
      "mas" # позволяет находить ID из официального Mac App Store
      "tt" # tarantool утилита
      "go@1.26"
      "expat"
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
