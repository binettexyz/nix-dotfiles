{ lib, ... }:
{

  imports = [
    ../../nixos/server
    ../../nixos/minimal.nix
  ];

  ## Custom modules ##
  modules = {
    bootloader = "rpi4";
    device = {
      type = "server";
      netDevices = [
        "eth0"
        "wlan0"
      ];
    };
    server.containers = {
      adGuardHome.enable = true;
      nextcloud.enable = true;
      vaultwarden.enable = false;
    };
    system = {
      home.enable = true;
    };
  };

  ## Networking ##
  networking = {
    hostName = "kageyami";
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless.interfaces = [ "wlan0" ];
  };

  nix.settings.max-jobs = 4;
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  boot.tmp.useTmpfs = lib.mkForce false;

}
