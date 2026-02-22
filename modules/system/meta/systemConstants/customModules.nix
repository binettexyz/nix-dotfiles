{
  flake.modules.generic.custom =
    { config, lib, ... }:
    {
      options = {
        my.baseDomain = lib.mkOption {
          type = lib.types.str;
          default = "jbinette.xyz";
          description = "Base domain name for my homelab";
        };
        meta = {
          username = lib.mkOption {
            description = "Main username";
            type = lib.types.str;
            default = "binette";
          };
          homePath = lib.mkOption {
            description = "Home directory";
            type = lib.types.path;
            default = "/home/${config.meta.username}";
          };
          configPath = lib.mkOption {
            description = "Location of this config";
            type = lib.types.path;
            default = "${config.meta.homePath}/.config/nixos";
          };
        };
        modules = {
          gaming = {
            enable = lib.mkEnableOption "Enable Gaming";
            device.isSteamdeck = lib.mkOption {
              description = "If device is a steamdeck";
              default = false;
            };
            services.sunshine.enable = lib.mkEnableOption "Enable Sunshine";
          };
          homelab = {
          };
        };
      };
    };
}
