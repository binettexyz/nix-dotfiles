{
  lib,
  flake,
  ...
}: {
  imports = [
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence
  ];

  ## Custom modules ##
  modules = {
    bootloader.default = "rpi4";
    server.containers = {
      gitea.enable = true;
    };
    system = {
      home.enable = true;
    };
  };

  services.syncthing.settings.folders = {
    "gameSaves" = {
      path = "/data/gaming/saves";
      devices = ["seiryu" "gyorai"];
    };
    "notes" = {
      path = "/data/library/notes";
      devices = ["seiryu" "hayate"];
    };
  };
}
