{ config, flake, lib, pkgs, system, ... }:
let
  inherit (config.meta) username;
in
  {
    imports = [
      ./audio.nix
      ./bootloader.nix
      ./desktopEnvironment.nix
      ./gaming
      #./home.nix
      ./locale.nix
      ./meta.nix
      ./security.nix
      ./ssh.nix
      ./system.nix
      ./user.nix
      ../modules
    ];
  
    /* ---Jovian-NixOS--- */
    jovian.steam = {
      enable = true;
      user = "binette";
      desktopSession = "plasma";
      autoStart = true;
    };
  
    jovian.devices.steamdeck = {
      enable = true;
      autoUpdate = true;
    };
  
    jovian.decky-loader = {
      enable = true;
      user = "binette";
    };
  
    environment.systemPackages = with pkgs; [
      jupiter-dock-updater-bin
      steamdeck-firmware
    ];
  
    /* ---User--- */
    users.users.${username}.group = lib.mkforce "decky";
    users.groups.decky = {};
  
    /* ---Xserver--- */
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
    
    /* ---Remove some settings I dont want--- */
    boot.kernel.sysctl = lib.mkForce {};
    services.logind.extraConfig = lib.mkForce "";
    services.udev.extraRules = lib.mkForce "";
    systemd.oomd.enable = lib.mkForce false;
  }
