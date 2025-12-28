{ pkgs, ... }:

{
  ############################
  # Finder
  ############################
  system.defaults.finder = {
    AppleShowAllExtensions = true;      # всегда показывать расширения файлов
    FXPreferredViewStyle = "clmv";      # Column View (удобно для навигации)
    ShowPathbar = true;                 # путь внизу окна Finder
    ShowStatusBar = true;               # статус-бар
    _FXShowPosixPathInTitle = true;     # полный POSIX-путь в заголовке окна
  };

  ############################
  # Dock
  ############################
  system.defaults.dock = {
    autohide = true;                    # автоматически скрывать Dock
    show-recents = false;               # убрать "Recent apps" (недавно открытые приложения)
    tilesize = 48;                      # размер иконок Dock
    mineffect = "scale";                # анимация сворачивания окон
    orientation = "bottom";             # снизу (left/right тоже можно)
  };

  ############################
  # Глобальные настройки macOS
  ############################
  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    AppleInterfaceStyle = "Dark";       # тёмная тема
    InitialKeyRepeat = 15;              # задержка перед повтором клавиш
    KeyRepeat = 2;                      # скорость повтора клавиш
    NSAutomaticSpellingCorrectionEnabled = false; # «Умные» автозамены слов/текста
    NSAutomaticCapitalizationEnabled = false; # автоматическое добавление заглавной буквы
    NSAutomaticQuoteSubstitutionEnabled = false; # “умные кавычки”
    NSAutomaticDashSubstitutionEnabled = false; # замена -- на длинное тире
    NSAutomaticPeriodSubstitutionEnabled = false; # вставка точки двойным пробелом
  };

  system.defaults.CustomUserPreferences.NSGlobalDomain = {
    "com.apple.swipescroll.selection" = true; # нормальное выделение при scroll
  };

  ############################
  # Trackpad / Mouse
  ############################
  system.defaults.trackpad = {
    Clicking = true;                    # tap-to-click
    TrackpadRightClick = true;          # правый клик двумя пальцами
    TrackpadThreeFingerDrag = false;     # drag тремя пальцами
  };

  system.defaults.CustomUserPreferences.".GlobalPreferences" = {
    "com.apple.mouse.scaling" = 1.5;       # скорость мыши
    "com.apple.trackpad.scaling" = 0.6875; # скорость трекпада
  };

  ############################
  # Раскладки клавиатуры (только ABC + Russian - PC)
  ############################
  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    # раскладка по умолчанию
    AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.ABC";

    # включены (видны в переключателе) только две раскладки
    AppleEnabledInputSources = [
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 252;   "KeyboardLayout Name" = "ABC"; }
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 19458; "KeyboardLayout Name" = "RussianWin"; }
    ];

    # выбранные раскладки
    AppleSelectedInputSources = [
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 252;   "KeyboardLayout Name" = "ABC"; }
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 19458; "KeyboardLayout Name" = "RussianWin"; }
    ];

    # история — чтобы “лишние” не всплывали обратно
    AppleInputSourceHistory = [
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 252;   "KeyboardLayout Name" = "ABC"; }
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 19458; "KeyboardLayout Name" = "RussianWin"; }
    ];
  };

  ############################
  # Звук запуска macOS
  ############################
  system.startup.chime = false;


  ############################
  # Применение изменений
  ############################
  system.activationScripts.reloadUI.text = ''
    /usr/bin/killall Dock || true
    /usr/bin/killall Finder || true
    /usr/bin/killall SystemUIServer || true
  '';
}
