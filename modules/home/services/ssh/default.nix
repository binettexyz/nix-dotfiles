{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = {
    enable = mkOption {
      description = "edit ssh config";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          identityFile = "${config.home.homeDirectory}/.ssh/id-ed25519";
        };
        "nas" = {
          hostname = "100.71.254.90";
          user = "${config.home.username}";
          port = 704;
        };
      };
    };

  };

}

