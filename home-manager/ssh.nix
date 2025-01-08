{ pkgs, config, lib, ... }:
with lib;

{

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "desktop-server" = {
          hostname = "100.69.22.72";
          user = "${config.home.username}";
          port = 704;
        };
      };
    };

}

