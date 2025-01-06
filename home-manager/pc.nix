{ pkgs, ... }: {

  imports = [
    ./dwm
    ./librewolf.nix
    ./minimal.nix
    #./mpv
    ./newsboat.nix
  ];

  home.packages = with pkgs; [
    gammastep
    hsetroot
    #stable.maim
    mupdf
    newsboat
    nsxiv
    pamixer
    pulsemixer
    #stable.slop
    texlive.combined.scheme-full
    trackma-qt
    udiskie
    xdotool
    xdragon # drag-n-drop tool
    xorg.xev
    xorg.xinit
    xorg.xmodmap
    xorg.xdpyinfo
    xorg.xkill
    zathura
    #TODO unclutter-xfixes
    #TODO xbanish # Hides the mouse when using the keyboard
      # emails
#   mutt-wizard
#   neomutt
#   isync
#   msmtp
#   lynx
#   notmuch
#   abook
#   urlview
#   mpop
#    rcon
  ];

  services.udiskie = {
    enable = true;
    tray = "never";
  };

  xdg = {
      # Some applications like to overwrite this file, so let's just force it
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications =
      let
        browser = "librewolf.desktop";
      in {
        "application/pdf" = [ "pdf.desktop" ];
        "application/postscript" = [ "pdf.desktop" ];
        "application/rss+xml" = [ "rss.desktop" ];

        "image/png" = [ browser ];
        "image/jpeg" = [ "img.desktop" ];
        "image/gif" = [ "img.desktop" ];
        "inode/directory" = [ "file.desktop" ];

        "text/x-shellscript" = [ "text.desktop" ];
        "text/plain" = [ "text.desktop" ];
        "text/html" = [ "text.desktop" ];

        "video/x-matroska" = [ "video.desktop" ];

        "x-scheme-handler/magnet" = [ "torrent.desktop" ];
        "x-scheme-handler/mailto" = [ "mail.desktop" ];
        "x-scheme-handler/http" = [ browser ];
        "x-scheme-handler/https " = [ browser ];
        "x-scheme-handler/about" = [ browser ];
        "x-scheme-handler/unknown" = [ browser ];
      };
    };
  };

  xresources.path = "/home/binette/.config/x11/xresources";
  xresources.properties = {
    /* --- Xft --- */
    "Xft.antialias" = 1;
    "Xft.hinting" = 1;
#    "Xft.dpi" = 96;
    "Xft.rgba" = "rgb";
    "Xft.lcdfilter" = "lcddefault";

    /* --- Xterm --- */
    "xterm.termName" = "xterm-256color";
    "xterm.vt100.locale" = false;
    "xterm.vt100.utf8" = true;
      # Backspace and escape fix
    "xterm.vt100.metaSendsEscape" = true;
    "xterm.vt100.backarrowKey" = false;
    "xtermttyModes" = "erase ^?";
  };



}
