{ config, flake, lib, pkgs, system, ... }:
let
  inherit (config.meta) username;
  inherit (config.modules.system.desktopEnvironment) default;
  default = desktopEnvironment;
in {

  config = lib.mkIf config.device == "gaming-handheld" {
    /* ---Jovian-NixOS--- */
    jovian.steam = {
      enable = true;
      user = username;
      desktopSession = desktopEnvironment;
      autoStart = true;
    };
  
    jovian.devices.steamdeck = {
      enable = true;
      autoUpdate = true;
    };
  
    jovian.decky-loader = {
      enable = true;
      user = username;
    };
  
    environment.systemPackages = with pkgs; [
      jupiter-dock-updater-bin
      steamdeck-firmware
    ];
  
    /* ---Xserver--- */
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
    
    /* ---Remove some settings I dont want--- */
    boot.kernel.sysctl = lib.mkForce {};
    services.logind.extraConfig = lib.mkForce "";
    services.udev.extraRules = lib.mkForce "";
    systemd.oomd.enable = lib.mkForce false;
  };

}
