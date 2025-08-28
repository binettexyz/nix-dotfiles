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
    deviceType,
    deviceTags ? [],
    hostname,
    gpuType ? "",
    system ? "x86_64-linux",
    nixosSystem ? nixpkgs.lib.nixosSystem,
    extraMods ? [],
    extraOverlays ? [],
  }: {
    nixosConfigurations.${hostname} = nixosSystem {
      inherit system;
      modules =
        [
          ../hosts/${hostname}/config.nix
          ../hosts/${hostname}/hardware.nix
          ../modules/default.nix
          ../modules/custom
          ../overlays
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
        ]
        ++ extraMods;
      specialArgs = {
        inherit system;
        flake = self;
        deviceType = deviceType;
        deviceTags = deviceTags;
        gpuType = gpuType;
        hostname = hostname;
      };
    };
  };

  # https://github.com/nix-community/home-manager/issues/1510
  mkHomeConfig = {
    hostname,
    username ? "binette",
    homePath ? "/home",
    configuration ? ../home-manager/desktop.nix,
    deviceType,
    system ? "x86_64-linux",
    homeManagerConfiguration ? home.lib.homeManagerConfiguration,
  }: let
    pkgs = import nixpkgs {inherit system;};
    homeDirectory = "${homePath}/${username}";
  in {
    homeConfigurations.${hostname} = homeManagerConfiguration rec {
      inherit pkgs;
      modules = [
        (
          {...}: {
            home = {inherit username homeDirectory;};
            imports = [configuration];
          }
        )
      ];
      extraSpecialArgs = {
        inherit inputs system;
        flake = self;
        #super = {
        #device.type = deviceType;
        #meta.username = username;
        #};
      };
    };

    apps.${system}."homeActivations/${hostname}" = mkApp {
      drv = self.outputs.homeConfigurations.${hostname}.activationPackage;
      exePath = "/activate";
    };
  };
}
