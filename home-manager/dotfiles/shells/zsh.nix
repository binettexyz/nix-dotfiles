{config, pkgs, ...}: {
  programs.zsh = {
    enable = true;
    # zsh directory
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;

    sessionVariables = {
      # Reduce time to wait for multi-key sequences
      KEYTIMEOUT = 1;
      # zsh-users config
      ZSH_AUTOSUGGEST_USE_ASYNC = 1;
      ZSH_HIGHLIGHT_HIGHLIGHTERS = [
        "main"
        "brackets"
        "cursor"
      ];
    };

    # .zshrc
    initContent = ''
      # Enable vcs_info for Git
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git:*' formats '%F{3}(%b)%f'  # Gruvbox Aqua for branch name
      precmd() { vcs_info } # Update vcs_info before each prompt

      autoload -U colors && colors # Load colors
      setopt promptsubst
      PROMPT='%B%F{5}[%F{6}%n%F{4} %~%F{5}]''${vcs_info_msg_0_}%f$%b '
      RPS1='%F{3}%*%f'  # Yellow timestamp
      stty stop undef		# Disable ctrl-s to freeze terminal.
      setopt interactive_comments

      setopt inc_append_history # each command is immediately appended to your history file.

      bindkey -v
      export KEYTIMEOUT=1

      bindkey '^@' autosuggest-accept
      bindkey '^h' autosuggest-clear
    '';

    # history settings
    history = {
      save = 10000000;
      size = 10000000;
      path = "/home/binette/.cache/zsh/history";
      expireDuplicatesFirst = true;
    };

    dirHashes = {
      docs = "$HOME/documents";
      vids = "$HOME/videos";
      pics = "$HOME/pictures";
      dl = "$HOME/downloads";
      git = "$HOME/.git";
      repos = "$HOME/.git/repos";
      nix = "/etc/nixos";
      movies = "/media/nas/videos/movies";
      tv = "/media/nas/videos/tv";
      animes = "/media/nas/videos/animes";
    };

    envExtra = ''
        # Use neovim for vim if present.
      [ -x "$(command -v nvim)" ] && alias vim="nvim" e="nvim" vimdiff="nvim -d"

        # doas not required for some system commands
      for command in mount umount eject su shutdown systemctl poweroff reboot ; do
            alias $command="doas $command"
      done; unset command

        #Start wayland session on TTY 1 if nothing is already running.
      #[ "$(tty)" = "/dev/tty1" ] && [ "$(echo $XDG_SESSION_TYPE)" != "wayland" ] && qtile start -b wayland

    '';

    plugins = [
      # to find sha256, keep it empty and the build error will find it for you
      {
        name = "zsh-vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "f82c4c8f4b2bdd9c914653d8f21fbb32e7f2ea6c";
          sha256 = "sha256-CkU0qd0ba9QsPaI3rYCgalbRR5kWYWIa0Kn7L07aNUI=";
        };
      }
      {
        name = "Fast Syntax Highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
          sha256 = "sha256-RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
        };
      }
      {
        name = "zsh-autopair";
        file = "zsh-autopair.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "449a7c3d095bc8f3d78cf37b9549f8bb4c383f3d";
          sha256 = "sha256-3zvOgIi+q7+sTXrT+r/4v98qjeiEL4Wh64rxBYnwJvQ=";
        };
      }
    ];
  };

  programs.dircolors.enable = true;
}
