{ lib, flake, ... }:
{

  imports = [
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence
  ];

  ## Custom modules ##
  modules = {
    bootloader.default = "rpi4";
    server.containers = {
#      adGuardHome.enable = true;
      nextcloud.enable = true;
#      vaultwarden.enable = false;
    };
    system = {
      home.enable = true;
    };
  };

}
