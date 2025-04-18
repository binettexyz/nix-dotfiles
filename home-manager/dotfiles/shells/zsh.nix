{
  pkgs,
  config,
  lib,
  super,
  ...
}:
with lib;

{

  programs.zsh = {
    enable = true;
    # zsh directory
    dotDir = ".config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    #      enableSyntaxHighlighting = true;
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
    initExtra = ''
      autoload -U colors && colors

      autoload -Uz vcs_info
      # Enable vcs_info for Git
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git:*' formats '%F{3}(%b)%f'  # Gruvbox Aqua for branch name

      # Update vcs_info before each prompt
      precmd() { vcs_info }

      setopt promptsubst
      PROMPT='%B%F{5}[%F{6}%n%F{4} %~%F{5}]''${vcs_info_msg_0_}%f$%b '
      RPS1='%F{3}%*%f'  # Yellow timestamp

      setopt interactive_comments

        # Use lf to switch directories and bind it to ctrl-o
      lfcd () {
        tmp="$(mktemp)"
        lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
           dir="$(cat "$tmp")"
           rm -f "$tmp" >/dev/null
           [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
        fi
      }

      bindkey '^ ' autosuggest-accept
      bindkey '^h' autosuggest-clear
    '';

    # history settings
    history = {
      save = 1000;
      size = 1000;
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
      dots = "/nix/persist/home/binette/.dotfiles";
      nix = "/etc/nixos";
      movies = "/media/nas/videos/movies";
      tv = "/media/nas/videos/tv";
      animes = "/media/nas/videos/animes";
    };

    envExtra = ''
        # Use neovim for vim if present.
      [ -x "$(command -v nvim)" ] && alias vim="nvim" e="nvim" vimdiff="nvim -d"

        # Use $XINITRC variable if file exists.
      [ -f "$XINITRC" ] && alias sx="sx sh $XINITRC"

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
          rev = "debe9c8ad191b68b143230eb7bee437caba9c74f";
          sha256 = "sha256-rgC1lKyZluYHi4Fk8zUSgMM/UqrJ6QcwYGvaDyuWAxo=";
        };
      }
      {
        name = "Fast Syntax Highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "770bcd986620d6172097dc161178210855808ee0";
          sha256 = "sha256-T4k0pbT7aqLrIRIi2EM15LXCnpRFHzFilAYfRG6kbeY=";
        };
      }
      {
        name = "zsh-autopair";
        file = "zsh-autopair.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
          sha256 = "sha256-PXHxPxFeoYXYMOC29YQKDdMnqTO0toyA7eJTSCV6PGE=";
        };
      }
    ];
  };
  programs.dircolors.enable = true;

}
