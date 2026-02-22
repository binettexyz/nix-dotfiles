{ inputs, lib, ... }:
{
  # Helper functions for creating system / home-manager configurations

  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {

    mkNixos = system: host: {
      ${host} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.nixosModules.${host}
          {
            networking.hostName = "${host}";
            nixpkgs.hostPlatform = system;
          }
        ];
      };
    };

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [ inputs.self.homeManagerModules.${name} ];
      };
    };

  };
}
