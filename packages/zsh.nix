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
      # Загружаем переменные Home Manager в каждый интерактивный zsh.
      # Это нужно для библиотек из Nix store (например, libmagic).
      if [[ -r /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh ]]; then
        source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
      fi

      # грузим powerlevel10k из nixpkgs
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # грузим твой конфиг p10k, если он существует
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      eval "$(ssh-agent -s)" >/dev/null 
      ssh-add ~/.ssh/id_ed25519 2>/dev/null

      export PATH="/Library/Application Support/VKey.app/Contents/MacOS/:$PATH"
    '';

    # programs.zsh.profileExtra = ''
    #   source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    # '';
  };

  home.packages = [
    pkgs.zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ../conf/zsh/p10k.zsh;
}