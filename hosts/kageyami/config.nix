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
      nextcloud.enable = true;
      gitea.enable = true;
    };
    system = {
      home.enable = true;
    };
  };

}
