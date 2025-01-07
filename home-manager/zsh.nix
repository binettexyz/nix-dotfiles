{ pkgs, config, lib, super, ... }:
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
        ZSH_HIGHLIGHT_HIGHLIGHTERS = [ "main" "brackets" "cursor" ];
      };
  
        # .zshrc
      initExtra = ''
        autoload -U colors && colors
        setopt promptsubst
        PS1="%B%{$fg[magenta]%}[%{$fg[cyan]%}%n%{$fg[blue]%} %~%{$fg[magenta]%}]%{$reset_color%}$%b "
        RPS1="%F{8}%*" # Set right prompt to show time

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
  
        # aliases directories
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
  
        # history settings
      history = {
        save = 1000;
        size = 1000;
        path = "/home/binette/.cache/zsh/history";
        expireDuplicatesFirst = true;
      };
  
        # aliases
      shellAliases = {
        copy = "${pkgs.xclip}/bin/xclip -selection c";
        paste = "${pkgs.xclip}/bin/xclip -selection c -o";
          # Nixos related aliases.
        nixsh = "nix-shell -p";
        nixswitch = "doas nix-store --verify; pushd /etc/nixos; doas nixos-rebuild switch --flake .#; popd";
        nixbuild = "doas nix-store --verify; pushd /etc/nixos; doas nixos-rebuild build --flake .#; popd";
        nixrb = "pushd /etc/nixos; doas nixos-rebuild switch --rollback; popd";
        nixtest = "pushd /etc/nixos; doas nixos-rebuild test --flake .#; popd";
        nixup = "pushd /etc/nixos; doas nix flake update; popd";
        nixq = "nix-store -q --requisites /run/current-system/sw | wc -l";
        cleanup = "doas nix-collect-garbage -d";
        bloat = "nix path-info -Sh /run/current-system";

        sudo = "doas su";

          # Naviguation
        ".." = "cd ..";
        "..." = "cd ../..";
        ".3" = "cd ../../..";
        ".4" = "cd ../../../..";
        ".5" = "cd ../../../../..";

          # Custom packages script
        lf = "lfrun";
        pwgen = "pwgen -1yn 12 10";
        ncdu = "${pkgs.dua}/bin/dua interactive";
        xterm = "${pkgs.xterm}/bin/xterm -e zsh";

          # clipboard
	      c = "${pkgs.xclip}/bin/xclip";
	      cm = "${pkgs.xclip}/bin/xclip -selection clipboard";
	      v = "${pkgs.xclip}/bin/xclip -o";

          # confirm before overwriting something
	      cp = "cp -riv";
	      mv = "mv -iv";
	      rm = "rm -rifv";
	      mkdir = "mkdir -pv";

          # colorize
	      ls = "${pkgs.eza}/bin/eza -hal --color=always --group-directories-first -s extension";
      	cat = "${pkgs.bat}/bin/bat --paging=never --style=plain";
        tree = "${pkgs.eza}/bin/eza --tree --icons";
        diff = "diff --color=auto";
        ip = "ip --color=auto";

          # Adding flags
        df = "df -h";
        free = "free -m";
        jctl = "journalctl -p 3 -xb";

          # git
#	      addup = "git add -u";
#	      addall = "git add .";
#	      branch = "git branch";
#	      checkout = "git checkout";
#	      clone = "git clone";
#	      commit = "git commit -m";
#	      fetch = "git fetch";
#	      pull = "git pull origin";
#	      push = "git push origin";
#	      status = "git status";
#	      tag = "git tag";
#	      newtag = "git tag -a";
#	      subadd = "git submodule add";
#	      subup = "git submodule update --remote --merge";

          # fetch computer specs
        pfetch = "curl -s https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch | sh";
      };
  
      envExtra = (mkMerge [(
          ''
                # Use neovim for vim if present.
              [ -x "$(command -v nvim)" ] && alias vim="nvim" e="nvim" vimdiff="nvim -d"
        
                # Use $XINITRC variable if file exists.
              [ -f "$XINITRC" ] && alias sx="sx sh $XINITRC"
        
                # doas not required for some system commands
              for command in mount umount eject su shutdown systemctl poweroff reboot ; do
                    alias $command="doas $command"
              done; unset command

              . "$HOME/.config/shell/profile"
          ''
      )
#TODO fix      (mkIf super.services.displayManager.sddm.enable (
#          ''
#              . "$HOME/.config/shell/profile"
#          ''
#      ))
#      (mkIf (super.services.displayManager.sddm.enable == false) (
#          ''
#              if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#                  . "$HOME/.config/shell/profile" && exec sx sh $HOME/.config/x11/xinitrc &> /dev/null;
#              else
#                  . "$HOME/.config/shell/profile"
#              fi
#          ''
#      ))
    ]);
  
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
