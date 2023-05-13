/* --Function to configure a nixosSystem-- */
hostname: {
  inputs
 , lib
 , unstable
 , nix-colors
 , nixpkgs ? inputs.unstable
 , system ? "x86_64-linux"
 , extraMods ? [ ]
 , extraOverlays ? [ ]
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = inputs // {
    inherit inputs system;
  };

  modules = [
    ../hosts/${hostname}/config.nix
    ../shared/adblock.nix
    ../overlays
    { networking.hostName = hostname; }

    inputs.home.nixosModules.home-manager {
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs nix-colors; };
        users.binette = (./.. + "/hosts/${hostname}/user.nix");
      };
      nixpkgs.overlays = [ /* powercord-overlay.overlay nur.overlay */ ];
    }

  ] ++ extraMods;
}
