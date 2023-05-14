{ pkgs, ... }: {

  imports = [
    ./dwm
    ./librewolf.nix
    ./minimal.nix
    ./mpv
    ./newsboat.nix
  ];

  home.packages = with pkgs; [
    bitwarden
    gammastep
    hsetroot
    libreoffice-fresh
    #stable.maim
    mupdf
    newsboat
    nsxiv
    pamixer
    playerctl
    pulsemixer
    #stable.slop
    texlive.combined.scheme-full
    trackma-qt
    tremc
    udiskie
    xdotool
    xdragon
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

  programs.zsh.shellAliases = {
    copy = "${pkgs.xclip}/bin/xclip -selection c";
    paste = "${pkgs.xclip}/bin/xclip -selection c -o";
  };

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

}
