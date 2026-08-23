{ lib, pkgs, ... }:
{
  ############################
  # Finder
  ############################
  system.defaults.finder = {
    AppleShowAllExtensions = true;      # всегда показывать расширения файлов
    FXPreferredViewStyle = "clmv";      # Column View (удобно для навигации)
    FXRemoveOldTrashItems = true;       # автоматически удалять из корзины через 30 дней
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
    expose-animation-duration = 0.0;    # убирает задержку анимации Spaces
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
    _HIHideMenuBar = true; # Автоматически скрывать строку меню
    NSAutomaticWindowAnimationsEnabled = false; # отключение анимаций окон
  };

  system.defaults.CustomUserPreferences = {
    NSGlobalDomain = {
      "com.apple.swipescroll.selection" = true; # нормальное выделение при scroll
      NSReduceMotion = true;                    # Уменьшить движение (рабочий ключ, но через CustomUserPreferences)
    };
    ############################
    # Dock / Hot Corners
    ############################
    "com.apple.dock" = {
      "wvous-tl-corner" = 1;
      "wvous-tl-modifier" = 0;
      "wvous-tr-corner" = 1;
      "wvous-tr-modifier" = 0;
      "wvous-bl-corner" = 1;
      "wvous-bl-modifier" = 0;
      "wvous-br-corner" = 1;
      "wvous-br-modifier" = 0;
    };
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
  system.activationScripts.postActivation.text = lib.mkAfter ''
    # Fix Homebrew python@3.x pyexpat linkage on macOS 26.x
    if [ -f /opt/homebrew/opt/expat/lib/libexpat.1.dylib ]; then
      for so in /opt/homebrew/Cellar/python@3.*/*/Frameworks/Python.framework/Versions/3.*/lib/python3.*/lib-dynload/pyexpat.cpython-3*-darwin.so; do
        if [ ! -f "$so" ]; then
          continue
        fi

        if /usr/bin/otool -L "$so" | /usr/bin/grep -q "/usr/lib/libexpat.1.dylib"; then
          /usr/bin/install_name_tool \
            -change /usr/lib/libexpat.1.dylib /opt/homebrew/opt/expat/lib/libexpat.1.dylib \
            "$so"
          /usr/bin/codesign --sign - --force "$so"
        fi
      done
    fi

    # Перезапуск процессов для применения настроек Dock и Finder
    /usr/bin/killall Dock || true
    /usr/bin/killall Finder || true
    /usr/bin/killall SystemUIServer || true
  '';
}
############################
# Возможные ошибки
############################
# если не может получить доступ, например к https://cache.nixos.org:
# - 1) проверь днс сети. не стоит ли там жестко какойто не понятный хост
# - 2) раскоментируй 2-й вариант в make update
# - 3) это все не гарантирует успеха

############################
# Ручная настройка
############################
# дисплеи->разрешение экрана->масштабирование->1312x848
#                           ->True Tone->true
# универсальный доступ->указатель->размер указателя->второе деление слева
# Универсальный доступ → Дисплей → Уменьшить движение
# ->Использовать функциональные клавиши F1, F2 и другие как стандартные->true
# ->клавиши модификации->клавиша control (^)->глобус
#                      ->клавиша с глобусом->^ Ctrl
# Строка меню->Показывать фон строки меню