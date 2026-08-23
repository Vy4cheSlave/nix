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

      # rerere = { # опасная хуйня у меня уже все успело 20 раз поламаться
      #   enabled = true;
      #   autoupdate = true;
      # };

      alias = {
        # st = "status -sb";
        # co = "checkout";
        # br = "branch";
        # lg = "log --oneline --decorate --graph --all";
      };
    };

    includes = [
      {
        condition = "gitdir:~/work/spimex/";
        contents = {
          user = {
            name = "vyacheslav";
            email = "vyacheslav.subochev@vkteam.ru";
          };
        };
      }
      {
        condition = "gitdir:~/work/script-migration/";
        contents = {
          user = {
            name = "Вячеслав Субочев";
            email = "vyacheslav.subochev@vkteam.ru";
          };
        };
      }
    ];
  };
}
