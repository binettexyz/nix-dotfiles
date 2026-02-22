{
  flake.nixosModules.memory = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };
  };
}
