#!/run/current-system/sw/bin/nix
{ config, pkgs, lib, ... }: {

  imports =
    [ # Include the results of the hardware scan.
      <home-manager/nixos>
      ./hardware-configuration.nix
      ./user/binette.nix

      ./modules/hardware/audio.nix
      ./modules/hardware/bluetooth.nix
      ./modules/hardware/intel-cpu.nix
      ./modules/hardware/intel-gpu.nix
      ./modules/hardware/power-management.nix
      ./modules/hardware/ssd.nix
      ./modules/hardware/touchpad.nix

      ./modules/network/adguard.nix

      ./modules/packages/common.nix
      ./modules/packages/x-common.nix

      ./modules/services/x.nix
#      ./modules/services/xrandr.nix
      ./modules/services/x/dwm.nix
      ./modules/services/x/picom.nix

      ./modules/sys/nix.nix
      ./modules/sys/tty.nix

      ./modules/boot.nix
      ./modules/fonts.nix
      ./modules/network.nix
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
