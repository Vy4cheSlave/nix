{ pkgs, ... }:
{ 
  # linux only
  home.packages = with pkgs; [
    libreoffice-bin
    
    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US
  ];
}
