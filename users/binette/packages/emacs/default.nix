# https://rycee.gitlab.io/nur-expressions/hm-options.html

{ config, pkgs, lib, ... }:
with pkgs;
with lib;
let
  readFile = builtins.readFile;
  nurNoPkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { pkgs = null; };
in {

  home-manager.users.binette = {

    imports = [
#      ./org
      ./packages.nix
      nurNoPkgs.repos.rycee.hmModules.emacs-init
    ];

    programs.emacs.enable = true;
    programs.emacs.overrides = import ./overrides { inherit pkgs; };


    programs.emacs.init = {
      enable = true;
      startupTimer = true;
      packageQuickstart = false;
      recommendedGcSettings = true;
      usePackageVerbose = false;

      earlyInit = ''
        ;; Disable some GUI distractions.
        (push '(menu-bar-lines . 0) default-frame-alist)
        (push '(tool-bar-lines . 0) default-frame-alist)
        (push '(vertical-scroll-bars . nil) default-frame-alist)
        (push '(fullscreen . maximized) initial-frame-alist)

        ;; Set up fonts early.
        (set-face-attribute 'default
                            nil
                            :height 140
                            :family "Source Code Pro")
        (set-face-attribute 'fixed-pitch nil :font "Source Code Pro" :height 100)
        (set-face-attribute 'variable-pitch nil :font "Cantarell" :height 150 :weight 'regular)

        ;; Configure color theme and modeline in early init to avoid flashing
        ;; during start.
        (require 'base16-theme)
        (load-theme 'base16-tomorrow-night t)

        (require 'doom-modeline)
        (setq doom-modeline-buffer-file-name-style 'truncate-except-project)
        (doom-modeline-mode)
      '';

      prelude = readFile ./prelude.el;

#      postlude = ''
#        (load "${./keybinds.el}")
#      '';

    };

    home.peristence."/nix/persist/home/binette" = {
      removePrefixDirectory = false;
      allowOther = true;
      files = [ ".emacs.d/emacs-dash.png" ];
    };
  };
}
