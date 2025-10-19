{
  config,
  hostname,
  lib,
  flake,
  system,
  deviceType,
  deviceTags,
  ...
}: let
  inherit (flake) inputs;
  cfg = config.modules.system.home;
in {
  options.modules.system.home = {
    enable =
      lib.mkEnableOption "home config"
      // {
        default = true;
      };
    username = lib.mkOption {
      description = "Main username";
      type = lib.types.str;
      default = config.meta.username;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.modules.system.home.username} = ../../hosts/${hostname}/user.nix;
      extraSpecialArgs = {
        inherit flake inputs system;
        hostname = hostname;
      };
    };
  };
}
