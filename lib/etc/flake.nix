{ self, nixpkgs, nixpkgs-unstable, home-manager, flake-utils, powercord-overlay, ... }@inputs:

let
  inherit (flake-utils.lib) eachDefaultSystem mkApp;
in
{

  mkNixOSConfig =
    { hostname
    , system
    , nixosSystem ? nixpkgs.lib.nixosSystem
    , extraModules ? [ ]
    }:
    {
      nixosConfigurations.${hostname} = nixosSystem {
        inherit system;
        modules = [
          ../hosts/${hostname}
          ../modules/system/adblock.nix
#          (import ../overlays { inherit flake nixpkgs system nixpkgs-unstable powercord-overlay; })

          home-manager.nixosModules.home-manager {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs; };
              users.binette = (./. + "/../hosts/${hostname}/users/binette.nix");
#              users.cath = (./. + "/../hosts/${hostname}/user/cath.nix");
            };
          }
        ] ++ extraModules;
        specialArgs = {
          inherit system;
          flake = self;
        };
      };

      apps.${system} = {
        "nixosActivations/${hostname}" = mkApp {
          drv = self.outputs.nixosConfigurations.${hostname}.config.system.build.toplevel;
          exePath = "/activate";
        };

        "nixosVMs/${hostname}" = let pkgs = import nixpkgs { inherit system; }; in
          mkApp {
            drv = pkgs.writeShellScriptBin "run-${hostname}-vm" ''
              env QEMU_OPTS="''${QEMU_OPTS:--cpu max -smp 4 -m 4096M -machine type=q35}" \
                ${self.outputs.nixosConfigurations.${hostname}.config.system.build.vm}/bin/run-${hostname}-vm
            '';
            exePath = "/bin/run-${hostname}-vm";
          };
      };
    };

  # https://github.com/nix-community/home-manager/issues/1510
  mkHomeConfig =
    { hostname
    , username ? "binette"
    , homePath ? "/home"
    , configuration ? ../home-manager
    , deviceType ? "desktop"
    , system ? "x86_64-linux"
    , homeManagerConfiguration ? home-manager.lib.homeManagerConfiguration
    }:
    {
      homeConfigurations.${hostname} = homeManagerConfiguration rec {
        inherit username configuration system;
        homeDirectory = "${homePath}/${username}";
        stateVersion = "22.11";
        extraSpecialArgs = {
          inherit system;
          flake = self;
        };
      };

      apps.${system}."homeActivations/${hostname}" = mkApp {
        drv = self.outputs.homeConfigurations.${hostname}.activationPackage;
        exePath = "/activate";
      };
    };
}
