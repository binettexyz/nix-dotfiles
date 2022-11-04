{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.cli.zsh;
in
{
  options.modules.cli.zsh = {
    enable = mkOption {
      description = "Enable Zsh package";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    programs.zsh = {
      enable = true;
        # zsh directory
      dotDir = ".config/zsh";
  
      enableCompletion = true;
      enableAutosuggestions = true;
#      enableSyntaxHighlighting = true;
      autocd = true;
  
        # .zshrc
      initExtra = ''
        autoload -U colors && colors
        setopt promptsubst
        PS1="%B%{$fg[magenta]%}[%{$fg[cyan]%}%n%{$fg[blue]%} %~%{$fg[magenta]%}]%{$reset_color%}$%b "
  
        setopt interactive_comments
  
        source "$HOME/.config/shell/aliasrc"
  
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
        path = "/nix/persist/home/binette/.cache/zsh/history";
        expireDuplicatesFirst = true;
      };
  
        # aliases
      shellAliases = {
          # Nixos related aliases.
        nixsh = "nix-shell -p";
        nixswitch = "pushd /etc/nixos; doas nixos-rebuild switch --flake .#; popd; notify-send ' NixOS' 'Rebuild complete!'";
        nixbuild = "pushd /etc/nixos; doas nixos-rebuild build --flake .#; popd; notify-send ' NixOS' 'Building complete!'";
        nixtest = "pushd /etc/nixos; doas nixos-rebuild test --flake .#; popd; notify-send ' NixOS' 'Test config applied!'";
        nixup = "pushd /etc/nixos; doas nix flake update; popd; notify-send '❄️ NixOS' 'Flake update complete!'";
        nixq = "nix-store -q --requisites /run/current-system/sw | wc -l";

        sudo = "doas su";

          # Naviguation
        ".." = "cd ..";
        "..." = "cd ../..";
        ".3" = "cd ../../..";
        ".4" = "cd ../../../..";
        ".5" = "cd ../../../../..";

          # Custom packages script
        lf = "lfrun";

          # Clipboard
        c = "xclip";
        cm = "xclip -selection clipboard";
        v = "xclip -o";

          # fetch computer specs
        pfetch = "curl -s https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch | sh";
      };
  
      envExtra = ''
          # Use neovim for vim if present.
        [ -x "$(command -v nvim)" ] && alias vim="nvim" e="nvim" vimdiff="nvim -d"

          # Use $XINITRC variable if file exists.
        [ -f "$XINITRC" ] && alias startx="startx $XINITRC"

          # doas not required for some system commands
        for command in mount umount eject su shutdown poweroff reboot ; do
	        alias $command="doas $command"
        done; unset command

        if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  	      . "$HOME/.config/shell/profile" && exec startx $HOME/.config/x11/xinitrc &> /dev/null;
        else
  	      . "$HOME/.config/shell/profile"
        fi
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
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "af6f8a266ea1875b9a3e86e14796cadbe1cfbf08";
            sha256 = "sha256-BjgMhILEL/qdgfno4LR64LSB8n9pC9R+gG7IQWwgyfQ=";
          };
        }
      ];
    };
  };

}
