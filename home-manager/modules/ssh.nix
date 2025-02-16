{ pkgs, config, lib, ... }:
with lib;

{

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "builder" = {
          user = "nixbuilder";
          hostname = "100.69.22.72";
          port = 704;
          identitiesOnly = true;
          identityFile = [ "/root/.ssh/nixbuilder" ];
        };
        "server" = {
          hostname = "100.69.22.72";
          port = 704;
        };
        "decky" = {
          hostname = "100.102.251.119";
          user = "${config.home.username}";
          port = 704;
        };
      };
    };

}

