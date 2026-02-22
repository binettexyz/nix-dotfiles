{
  flake.nixosModules.meta = {
    system.stateVersion = "25.11";
  };
  flake.modules.homeManager.meta = {
    home.stateVersion = "26.05";
  };
}
