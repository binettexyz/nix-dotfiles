{ config, lib, pkgs, flake, system, ... }:
let
  inherit (flake) inputs;
  inherit (config.networking) hostName;
  cfg = config.modules.system.home.enable;
in {

  /* ---Import Modules/Config--- */
  imports = [
    ../modules/meta.nix
    flake.inputs.home.nixosModules.home-manager
  ];

  options.modules.system.home = {
    enable = lib.mkEnableOption "home config" // { default = true; };
    username = lib.mkOption {
      description = "Main username";
      type = lib.types.str;
      default = config.meta.username;
    };
  };

  config = lib.mkIf config.modules.system.home.enable {
    home-manager = {
      useUserPackages = true;
      users.${config.modules.system.home.username} = ../../hosts/${hostName}/user.nix;
      extraSpecialArgs = {
        inherit flake system;
        super = config;
      };
    };
  };
}
