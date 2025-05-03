{...}: {
  programs.zsh = {
    enable = true;
    # zsh directory
    dotDir = ".config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    #syntaxHighlighting = {
    #enable = true;
    #highlighters = [
    #"main"
    #"brackets"
    #"cursor"
    #];
    #};
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

    antidote = {
      enable = true;
      plugins = [
        "jeffreytse/zsh-vi-mode"
        "hlissner/zsh-autopair"
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };
  };

  programs.dircolors.enable = true;
}
