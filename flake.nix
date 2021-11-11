{
  description = "system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, ... }:

  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

  lib = nixpkgs.lib;

  in {

    nixosConfigurations = {
      bin-laptop = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
