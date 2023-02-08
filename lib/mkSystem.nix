/* --Function to configure a nixosSystem-- */
hostname: {
  inputs
 , lib
 , modules ? [ ]
 , nixpkgs ? inputs.nixpkgs
 , overlays ? [ ]
 , system ? "x86_64-linux"
 , unstable
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = inputs // {
    inherit system;
    #hostname = hostname;
  };

  modules = [
    { networking.hostName = hostname; }
    (./.. + "/hosts/${hostname}/config.nix")
    (./.. + "/hosts/${hostname}/hardware.nix")
    ../modules/system/adblock.nix
    (import ../overlays { inherit inputs lib nixpkgs system unstable; }) 

    inputs.sops-nix.nixosModules.sops
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.impermanence.nixosModules.impermanence 
    inputs.home.nixosModules.home-manager {
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs; };
        users.binette = (./.. + "/hosts/${hostname}/user.nix");
      };
      nixpkgs.overlays = [
        (final: prev: {
          gruvbox-material-gtk =
          prev.callPackage ./overlays/gtk-themes/gruvbox-material.nix { };
        })
#        powercord-overlay.overlay
#        nur.overlay
      ];
    }

  ] ++ modules;
}
