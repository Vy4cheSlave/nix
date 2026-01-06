{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Vy4cheSlave";
        email = "slav.subocheff@yandex.ru";
      };

      init.defaultBranch = "main";
      # pull.rebase = true;
      # core.editor = "code --wait";

      # опционально: удобные алиасы
      alias = {
        # st = "status -sb";
        # co = "checkout";
        # br = "branch";
        # lg = "log --oneline --decorate --graph --all";
      };
    };

    includes = [
      {
        condition = "gitdir:~/work/";
        contents = {
          user = {
            name = "vyacheslav";
            email = "vyacheslav.subochev@vkteam.ru";
          };
        };
      }
    ];
  };
}