{
  flake-utils,
  home,
  nixpkgs,
  unstable,
  self,
  stable,
  ...
} @ inputs: let
  inherit (flake-utils.lib) mkApp;
in {
  # --Function to configure a nixosSystem--
  mkNixOSConfig = {
    hostname,
    system ? "x86_64-linux",
    nixosSystem ? nixpkgs.lib.nixosSystem,
    extraMods ? [],
    extraOverlays ? [],
  }: {
    nixosConfigurations.${hostname} = nixosSystem {
      inherit system;
      modules =
        [
          {networking.hostName = hostname;}
          ../hosts/${hostname}/config.nix
          ../hosts/${hostname}/hardware.nix
          ../modules/custom
          ../overlays
          inputs.home.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
        ]
        ++ extraMods;
      specialArgs = {
        inherit system;
        flake = self;
        hostname = hostname;
      };
    };
  };

  # https://github.com/nix-community/home-manager/issues/1510
  mkHomeConfig = {
    hostname,
    username ? "binette",
    homePath ? "/home",
    homeDirectory ? "${homePath}/${username}",
    configuration ? ../home-manager/default.nix,
    system ? "x86_64-linux",
    homeManagerConfiguration ? home.lib.homeManagerConfiguration,
  }: let
    pkgs = import nixpkgs {inherit system;};
    homeDirectory = "${homePath}/${username}";
  in {
    homeConfigurations.${hostname} = homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ({ ... }: {
            home = { inherit username homeDirectory; };
            imports = [ configuration ];
          })
      ];
      extraSpecialArgs = {
        inherit inputs system;
        hostname = hostname;
      };
    };

    apps.${system}."homeActivations/${hostname}" = mkApp {
      drv = self.outputs.homeConfigurations.${hostname}.activationPackage;
      exePath = "/activate";
    };
  };
}
