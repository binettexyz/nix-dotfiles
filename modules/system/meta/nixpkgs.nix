{ inputs, ... }:
{
  flake.nixosModules.meta = {
    imports = [ inputs.self.nixosModules.defaultPackages ];
  };

  flake.modules.homeManager.meta = { };
}
