{ config, flake, lib, pkgs, system, ... }:
let
  inherit (config.meta) username;
in {

  imports = [
    flake.inputs.jovian-nixos.nixosModules.jovian
  ];

  config = lib.mkIf (config.device.type == "gaming-handheld") {
    /* ---Jovian-NixOS--- */
    jovian.steam = {
      enable = true;
      user = username;
        # Steamdeck's desktop mode. Need to force disable "services.xserver.displayManager".
      desktopSession = config.modules.system.desktopEnvironment.default;
        # Boot straight into gamemode.
      autoStart = true;
    };
  
    jovian.devices.steamdeck = {
      enable = true;
      autoUpdate = true; # Auto update firmware/bios. Can be manually be done if disabled with the tools in systemPackages bellow.
    };
  
    jovian.decky-loader = { # Requires enabling CEF remote debugging in dev mode settings.
      enable = true;
      user = username;
    };
  
    environment.systemPackages = with pkgs; [
      jupiter-dock-updater-bin # 'jupiter-dock-updater'.
      steamdeck-firmware # Gives us 'jupiter-biosupdate' and 'jupiter-controller-update'.
    ];


    /* ---Xserver--- */
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
  };

}
