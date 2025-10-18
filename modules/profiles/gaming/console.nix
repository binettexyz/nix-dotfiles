{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.meta) username;
in {
  config = lib.mkIf (config.modules.gaming.enable && lib.elem "console" config.device.tags) {
    jovian.steam = {
      enable = true;
      user = username;
      # Gamescope's desktop mode. Need to force disable "services.xserver.displayManager".
      desktopSession = config.modules.system.desktopEnvironment;
      # Boot straight into gamemode.
      autoStart = true;
    };

    jovian.devices.steamdeck = {
      enable = config.modules.gaming.device.isSteamdeck;
      autoUpdate = config.modules.gaming.device.isSteamdeck; # Auto update firmware/bios. Can be manually be done if disabled with the tools in systemPackages bellow.
    };

    jovian.decky-loader = {
      # Requires enabling CEF remote debugging in dev mode settings.
      enable = true;
      # Directory to store plugins as.
      stateDir = "/var/lib/decky-loader"; # Default
      user = username;
    };

    # Steamdeck firmwate updater
    environment.systemPackages = [pkgs.steamdeck-firmware];
  };
}
