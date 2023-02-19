{ config, lib, pkgs, flake, system, ... }:
let
  inherit (config.networking) hostName;
in
{
  options.nixos.home = {
    enable = lib.mkEnableOption "home config" // { default = true; };
    username = lib.mkOption {
      description = "Main username";
      type = lib.types.str;
      default = config.meta.username;
    };
  };

  config = lib.mkIf config.nixos.home.enable {
    home-manager = {
      useUserPackages = true;
      users.${config.nixos.home.username} = ../hosts/${hostName}/user.nix;
      extraSpecialArgs = {
        inherit flake system;
        super = config;
      };
    };
  };
}
