{ pkgs, ... }: {

  home-manager.users.binette.programs.lf = {
    enable = true;
    settings = {
      icons = false;
      drawbox = true;
      hidden = true;
      ignorecase = true;
      preview = true;
    };
    previewer.source = pkgs.writeShellScript "previewer.sh" ''
      #!/bin/sh
      case "$1" in
          *) highlight -O ansi "$1" || cat "$1";;
          *.zip) atool --list -- "$1" ;;
          *.tar*) atool --list -- "$1" ;;
          *.rar) atool --list -- "$1" ;;
          *.7z) atool --list -- "$1" ;;
          *.png) chafa --fill=block --symbols=block -c full -s 80x60 "$1" || exit 1;;
          *.pdf) pdftotext -l 10 -nopgbrk -q -- "$1" - ;;
      esac
    '';
  };

}
