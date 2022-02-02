#!/run/current-system/sw/bin/nix
{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
  {

    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        (import "${home-manager}/nixos")
        ./user/binette.nix

        ./modules/hardware/audio.nix
        ./modules/hardware/bluetooth.nix
        ./modules/hardware/amd-cpu.nix
        ./modules/hardware/amd-gpu.nix
        ./modules/hardware/ssd.nix
        ./modules/hardware/touchpad.nix

        ./modules/packages/common.nix
        ./modules/packages/x-common.nix

        ./modules/power-management/power-management.nix

        ./modules/services/x.nix
#        ./modules/services/xrandr.nix
        ./modules/services/x/dwm.nix
        ./modules/services/x/picom.nix

        ./modules/sys/nix.nix
        ./modules/sys/tty.nix

        ./modules/boot.nix
        ./modules/fonts.nix
        ./modules/network.nix
        ./modules/nixpkgsConfig.nix
        ./modules/security.nix
        ./modules/ssh.nix
        ./modules/torrent.nix
        ./modules/users.nix
      ];

      # Set your time zone.
    time.timeZone = "Canada/Eastern";
    location = {
      provider = "manual";
      latitude = 45.30;
      longitude = -73.35;
    };
      # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    system.stateVersion = "21.11";

}
