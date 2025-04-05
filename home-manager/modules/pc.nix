{ ... }:
{

  services.udiskie.enable = true;
  services.udiskie.tray = "never";

  # Some applications like to overwrite this file, so let's just force it
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser = "librewolf.desktop";
      in
      {
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

}
