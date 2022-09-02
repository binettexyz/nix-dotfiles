{
  description = "Binette's NixOS Configuration";

    # System's Input
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

#    discord-overlay = {
#      url = "github:InternetUnexplorer/discord-overlay";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

      # Suckless
    dwm = { url = "github:binettexyz/dwm"; flake = false; };
    st = { url = "github:binettexyz/st"; flake = false; };
    slstatus = { url = "github:binettexyz/slstatus"; flake = false; };
    dmenu = { url = "github:binettexyz/dmenu"; flake = false; };

    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
  };

    # System's Output
  outputs = {
    self,
    nixpkgs,
    nur,
    home-manager,
    impermanence,
    dwm,
    powercord-overlay,
    ...
  }@inputs: let

    system = "x86_64-linux"; # current system
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    lib = nixpkgs.lib;

      # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
    mkSystem = pkgs: system: hostname:
      pkgs.lib.nixosSystem {
        system = system;
        modules = [
          { networking.hostName = hostname; }
          (./. + "/hosts/${hostname}/system.nix")
          ./modules/system/adblock.nix
          ./overlays
          home-manager.nixosModules.home-manager {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs; };
              users.binette = (./. + "/hosts/${hostname}/user.nix");
            };
            nixpkgs.overlays = [
              nur.overlay
            ];
          }
        ];
        specialArgs = { inherit inputs; };
      };

  in {

      # Defining system
    nixosConfigurations = {
        #                               Architecture   Hostname
      desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
      x240 = mkSystem inputs.nixpkgs "x86_64-linux" "x240";
      t440p = mkSystem inputs.nixpkgs "x86_64-linux" "t440p";
      rpi4 = mkSystem inputs.nixpkgs "aarch64" "rpi4";
    };
  }; 
}

