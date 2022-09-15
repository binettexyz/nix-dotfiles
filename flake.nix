{
  description = "Binette's NixOS Configuration";

  /* --- System's Inputs--- */

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware = { url = "github:NixOS/nixos-hardware"; flake = false; };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    impermanence.url = "github:nix-community/impermanence";

      # Suckless
    dwm = { url = "github:binettexyz/dwm"; flake = false; };
    st = { url = "github:binettexyz/st"; flake = false; };
    slstatus-laptop = { url = "github:binettexyz/slstatus"; flake = false; };
    slstatus-desktop = { url = "github:binettexyz/slstatus/desktop"; flake = false; };
    dmenu = { url = "github:binettexyz/dmenu"; flake = false; };

      # Discord stuff
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    disc-betterReplies = { url = "github:cyyynthia/better-replies"; flake = false; };
    disc-doubleClickVC = { url = "github:discord-modifications/double-click-vc"; flake = false; };
    disc-muteNewGuild = { url = "github:RazerMoon/muteNewGuild"; flake = false; };
    disc-popoutFix = { url = "github:Nexure/PowerCord-Popout-Fix"; flake = false; };
    disc-screenshareCrack = { url = "github:discord-modifications/screenshare-crack"; flake = false; };
    disc-unindent = { url = "github:VenPlugs/Unindent"; flake = false; };
    disc-silentTyping = { url = "github:svby/powercord-silenttyping"; flake = false; };
    disc-gruvbox = { url = "github:binettexyz/discord-gruvbox"; flake = false; };
  };

  /* ---System's Output--- */

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    impermanence,
    powercord-overlay,
    ...
  }@inputs: let

    system = "x86_64-linux"; # current system
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    lib = nixpkgs.lib;

      # Credit: https://github.com/sioodmy/dotfiles/blob/main/flake.nix
    mkSystem = pkgs: system: hostname:
      pkgs.lib.nixosSystem {
        system = system;
        modules = [
          { networking.hostName = hostname; }
          (./. + "/hosts/${hostname}/system.nix")
          ./modules/system/adblock.nix
          (import ./overlays { inherit pkgs lib nixpkgs system nixpkgs-unstable; })
          home-manager.nixosModules.home-manager {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs; };
              users.binette = (./. + "/hosts/${hostname}/user.nix");
            };
            nixpkgs.overlays = [
              (final: prev: {
                gruvbox-material-gtk =
                  prev.callPackage ./overlays/gtk-themes/gruvbox-material.nix { };
              })
              powercord-overlay.overlay
#              nur.overlay
            ];
          }

        ];

        specialArgs = { inherit inputs; };
      };

  in {

    /* ---Defining Systems--- */

    nixosConfigurations = {
                                              /* Architecture    Hostname */
        # Workstation
      desktop = mkSystem inputs.nixpkgs-unstable "x86_64-linux"  "desktop";
        # Portable Laptop
      x240 = mkSystem inputs.nixpkgs-unstable    "x86_64-linux"  "x240";
        # Desktop Laptop
      t440p = mkSystem inputs.nixpkgs-unstable   "x86_64-linux"  "t440p";
        # Server
      rpi4 = mkSystem inputs.nixpkgs             "aarch64-linux" "rpi4";


    };
  }; 

}

