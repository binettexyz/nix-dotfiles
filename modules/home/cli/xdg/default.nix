{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.cli.xdg;
in
{
  options.modules.cli.xdg = {
    enable = mkOption {
      description = "Set xdg directories";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = false;
    
        documents = "$HOME/documents";
        download = "$HOME/downloads";
        pictures = "$HOME/pictures";
        videos = "$HOME/videos";
      };
      mimeApps = {
        enable = true;
        defaultApplications =
        let
          browser = "brave.desktop";
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
    xdg.configFile."mimeapps.list".force = true;
  };

}
