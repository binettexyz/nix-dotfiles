{ pkgs, config, lib, ... }:
with lib;

{

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
        };
        "nas" = {
          hostname = "100.71.254.90";
          user = "${config.home.username}";
          port = 704;
        };
      };
    };

}

