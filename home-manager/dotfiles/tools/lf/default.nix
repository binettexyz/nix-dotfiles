{
  pkgs,
  lib,
  ...
}:
{
  programs.lf = {
    enable = true;
    settings = {
      shell = "zsh";
      shellopts = "-eu";
      hidden = true;
      icons = true;
      drawbox = true;
      ignorecase = true;
      scrolloff = 10;
    };

    commands = {
      open = ''
         ''${{
           case $(file --mime-type "$(readlink -f $f)" -b) in
        application/pdf) setsid -f zathura $fx >/dev/null 2>&1 ;;
               text/*|application/json|inode/x-empty) $EDITOR $fx;;
        image/svg+xml) display -- $f ;;
        image/*) rotdir $f | grep -i "\.\(png\|jpg\|jpeg\|gif\|webp\|tif\|ico\)\(_large\)*$" |
         setsid -f nsxiv -aio 2>/dev/null | while read -r file; do
          [ -z "$file" ] && continue
          lf -remote "send select \"$file\""
          lf -remote "send toggle"
         done &
         ;;
        audio/*) mpv --audio-display=no $f ;;
        video/*) setsid -f mpv $f -quiet >/dev/null 2>&1 ;;
        application/pdf|application/vnd*|application/epub*) setsid -f zathura $fx >/dev/null 2>&1 ;;
        application/pgp-encrypted) $EDITOR $fx ;;
               *) for f in $fx; do setsid -f $OPENER $f >/dev/null 2>&1; done;;
           esac
         }}
      '';

      mkdir = ''$mkdir -p "$(echo $* | tr ' ' '\ ')" '';

      mktouch = ''$touch "$(echo $* | tr ' ' '\ ')" '';

      chmod = ''
        ''${{
          printf "Mode Bits: "
          read ans

          for file in "$fx"
          do
            chmod $ans $file
          done

          lf -remote 'send reload'
        }}
      '';

      setwallpaper = ''%cp "$f" ~/.config/wall.png && hsetroot -fill "$f" '';

      extract = ''
        ''${{
          clear; tput cup $(($(tput lines)/3)); tput bold
          set -f
          printf "%s\n\t" "$fx"
          printf "extract?[y/N]"
          read ans
          [ $ans = "y" ] && aunpack $fx
        }}
      '';

      zip = ''%zip -r "$f" "$f" '';
      tar = ''%tar cvf "$f.tar" "$f" '';
      targz = ''%tar cvzf "$f.tar.gz" "$f" '';
      tarbz2 = ''%tar cjvf "$f.tar.bz2" "$f" '';
    };

    extraConfig = ''

      set previewer ~/.config/lf/preview
      set cleaner ~/.config/lf/cleaner

      # Bindings
      # Remove some defaults
      map m
      map o
      map n
      map "'"
      map '"'
      map d
      map c
      map e
      map f

      # File Openers
      map e $$EDITOR "$f"
      map u $view "$f"
      map <c-f> $lf -remote "send $id select '$(fzf)'"
      map J $lf -remote "send $id cd $(sed -e 's/\s*#.*//' -e '/^$/d' -e 's/^\S*\s*//' ''${XDG_CONFIG_HOME:-$HOME/.config}/shell/bm-dirs | fzf)"
      # Archive Mappings
      map az zip
      map at tar
      map ag targz
      map ab tarbz2
      map E extract

      # Basic Functions
      map . set hidden!
      map DD delete
      map p paste
      map x cut
      map y copy
      map <enter> open
      map mf mkfile
      map md mkdir
      map <a-n> push :mkdir<space>
      map <a-m> push :mktouch<space>
      map ch chmod
      map bg setwallpaper
      map o open_config
      map r rename
      map R reload
      map C clear

      # Movement
      map gH cd /nix/persist/home/binette

      map gv. cd $HOME/videos

      map gp. cd ~/pictures
      map gps cd ~/pictures/screenshots
      map gpw cd ~/pictures/wallpapers

      map gd. cd ~/documents
      map gdl cd ~/downloads
      map gtg cd ~/.git/repos
      map gtn cd /etc/nixos
      map gc cd ~/.config
      map gl cd ~/.local
    '';
  };

  home.packages = [
    pkgs.ueberzug # Image preview
    pkgs.ffmpeg # for video file thumbnails
    #pkgs.ghostscript # pdf preview # FIXME: error with texlive
    pkgs.file # Shows the type of file
    pkgs.chafa
    #    pkgs.mediainfo
    #    pkgs.odt2txt
    #    pkgs.python39Packages.pdftotext
    #    pkgs.imagemagick
    #    pkgs.poppler
    #    pkgs.wkhtmltopdf
  ];

  home.file.".config/lf/cleaner".source = ./src/cleaner;
  home.file.".config/lf/preview".source = ./src/preview;
  home.file.".local/bin/lfrun".source = ./src/lfrun;
}
