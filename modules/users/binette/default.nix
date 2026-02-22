{ inputs, ... }:
{
  flake.nixosModules."binette" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      hostname = config.modules.device.hostname;
    in
    {
      home-manager.users."binette" = {
        imports = [ inputs.self.modules.homeManager."${hostname}Binette" ];
      };

      users = {
        defaultUserShell = lib.mkForce pkgs.fish;
        mutableUsers = false;
        groups."binette".gid = 1000;
        users."binette" = {
          uid = 1000;
          isNormalUser = true;
          createHome = true;
          home = "/home/binette";
          group = "binette";
          extraGroups = [
            "wheel"
            "binette"
            "users"
            "audio"
            "video" # "docker"
          ];
          hashedPassword = "$6$89SIC2h2WeoZT651$26x4NJ1vmX9N/B54y7mc5pi2INtNO0GqQz75S37AMzDGoh/29d8gkdM1aw6i44p8zWvLQqhI0fohB3EWjL5pC/";
        };
        users.root = {
          hashedPassword = "$6$rxT./glTrsUdqrsW$Wzji63op8yTEBoIEcWBc26KOlFJtqx.EKpsGV1A2bQT9oB1JKtrlfdArYICc/Ape.msHcj6ObyXlmRKTWTC/J.";
        };
      };
    };

  flake.modules.homeManager.binette =
    { config, pkgs, ... }:
    {
      # Set default directories without CAPS
      xdg.userDirs = {
        enable = true;
        createDirectories = false;
        desktop = "/home/${config.home.username}/desktop";
        documents = "/home/${config.home.username}/documents";
        download = "/home/${config.home.username}/downloads";
        pictures = "/home/${config.home.username}/pictures";
        videos = "/home/${config.home.username}/videos";
      };

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
            "image/png" = [ "img.desktop" ];
            "image/jpeg" = [ "img.desktop" ];
            "image/gif" = [ "img.desktop" ];
            "inode/directory" = [ "file.desktop" ];
            "text/x-shellscript" = [ "text.desktop" ];
            "text/plain" = [ "text.desktop" ];
            "text/html" = [ "text.desktop" ];
            "video/x-matroska" = [ "video.desktop" ];
            "x-scheme-handler/magnet" = [ "torrent.desktop" ];
            "x-scheme-handler/http" = [ browser ];
            "x-scheme-handler/https " = [ browser ];
            "x-scheme-handler/about" = [ browser ];
            "x-scheme-handler/unknown" = [ browser ];
          };
      };

      xdg.desktopEntries = {
        pdf = {
          name = "PDF Reader";
          type = "Application";
          exec = "${pkgs.zathura}/bin/zathura %f";
        };
        text = {
          name = "Text Editor";
          type = "Application";
          exec = "${pkgs.foot}/bin/foot -e ${pkgs.helix}/bin/hx %f";
        };
        img = {
          name = "Image Viewer";
          type = "Application";
          exec = "${pkgs.vimiv-qt}/bin/vimiv %f";
        };
        video = {
          name = "Video Player";
          type = "Application";
          exec = "mpv %f";
        };
      };
    };
}
