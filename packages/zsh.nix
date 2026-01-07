{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "";            # важно: иначе OMZ будет искать тему у себя и ругаться "not found"
      plugins = [ "git" ];
    };

    initContent = ''
      # грузим powerlevel10k из nixpkgs
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # грузим твой конфиг p10k, если он существует
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };

  home.packages = [
    pkgs.zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ../conf/zsh/p10k.zsh;
}