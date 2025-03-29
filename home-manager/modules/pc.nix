{ config, pkgs, lib, super, ... }: 
with lib;

{

    home.packages = with pkgs; [
      (mkIf (builtins.elem config.device.type == [ "workstation" "gaming-desktop" ] ) grim)
      slurp
      wl-clipboard
      wlr-randr
      vimiv-qt
      waylock
      rofi-wayland
      mupdf
      newsboat
      pamixer
      pulsemixer
      (mkIf (builtins.elem config.device.type == [ "workstation" "gaming-desktop" ]) texlive.combined.scheme-full)
      udiskie
      zathura
    ];

    services.udiskie = {
      enable = true;
      tray = "never";
    };

#    xdg = {
#        # Some applications like to overwrite this file, so let's just force it
#      configFile."mimeapps.list".force = true;
#      mimeApps = {
#        enable = true;
#        defaultApplications =
#        let
#          browser = "librewolf.desktop";
#        in {
#          "application/pdf" = [ "pdf.desktop" ];
#          "application/postscript" = [ "pdf.desktop" ];
#          "application/rss+xml" = [ "rss.desktop" ];
#  
#          "image/png" = [ browser ];
#          "image/jpeg" = [ "img.desktop" ];
#          "image/gif" = [ "img.desktop" ];
#          "inode/directory" = [ "file.desktop" ];
#  
#          "text/x-shellscript" = [ "text.desktop" ];
#          "text/plain" = [ "text.desktop" ];
#          "text/html" = [ "text.desktop" ];
#  
#          "video/x-matroska" = [ "video.desktop" ];
#  
#          "x-scheme-handler/magnet" = [ "torrent.desktop" ];
#          "x-scheme-handler/mailto" = [ "mail.desktop" ];
#          "x-scheme-handler/http" = [ browser ];
#          "x-scheme-handler/https " = [ browser ];
#          "x-scheme-handler/about" = [ browser ];
#          "x-scheme-handler/unknown" = [ browser ];
#        };
#      };
#    };

}
