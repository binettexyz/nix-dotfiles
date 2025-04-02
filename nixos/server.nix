{ config, flake, lib, pkgs, ... }: {

  imports = [ ./modules ];

  modules.server.containers = {
    adGuardHome.enable = true;
    nextcloud.enable = true;
    vaultwarden.enable = false;
  };

  device.type = "server";
  modules.system = {
    home.enable = true;
  };

  boot.tmp.useTmpfs = lib.mkForce false;

}
