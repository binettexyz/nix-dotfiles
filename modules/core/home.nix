{
  config,
  hostname,
  lib,
  flake,
  system,
  ...
}:
let
  cfg = config.modules.system.home;
in
{
  options.modules.system.home = {
    enable = lib.mkEnableOption "home config" // {
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
        inherit flake system;
        hostname = hostname;
      };
    };
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
