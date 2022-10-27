{
  description = "Binette's NixOS Configuration";

  /* --- System's Inputs--- */

  inputs = {
    /* --- Default Nixpkgs --- */
#    nixpkgs.follows = "master";

    /* --- Nixpkgs branches --- */
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/21.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    /* --- Others --- */
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "github:nix-community/home-manager/master";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";

    /* --- Suckless Software --- */
    dwm = { url = "github:binettexyz/dwm"; flake = false; };
    st = { url = "github:binettexyz/st"; flake = false; };
    slstatus-laptop = { url = "github:binettexyz/slstatus"; flake = false; };
    slstatus-desktop = { url = "github:binettexyz/slstatus/desktop"; flake = false; };
    dmenu = { url = "github:binettexyz/dmenu"; flake = false; };

      /* --- Discord stuff --- */
#    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
#    disc-betterReplies = { url = "github:cyyynthia/better-replies"; flake = false; };
#    disc-doubleClickVC = { url = "github:discord-modifications/double-click-vc"; flake = false; };
#    disc-muteNewGuild = { url = "github:RazerMoon/muteNewGuild"; flake = false; };
#    disc-popoutFix = { url = "github:Nexure/PowerCord-Popout-Fix"; flake = false; };
#    disc-screenshareCrack = { url = "github:discord-modifications/screenshare-crack"; flake = false; };
#    disc-unindent = { url = "github:VenPlugs/Unindent"; flake = false; };
#    disc-silentTyping = { url = "github:svby/powercord-silenttyping"; flake = false; };
#    disc-gruvbox = { url = "github:binettexyz/discord-gruvbox"; flake = false; };

    /* --- Minimize duplicate instances of inputs --- */
    home.inputs.nixpkgs.follows = "unstable";
    nix-gaming.inputs.nixpkgs.follows = "unstable";
    sops-nix.inputs.nixpkgs.follows = "unstable";
  };

  /* ---System's Output--- */

  outputs = {
    self,
    nixpkgs,
    unstable,
    nixos-hardware,
    home,
    impermanence,
#    powercord-overlay,
    sops-nix,
    ...
  }@inputs: let

    system = "x86_64-linux"; # current system
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    lib = nixpkgs.lib;

    mkSystem = pkgs: system: hostname:
      pkgs.lib.nixosSystem {
        system = system;
        modules = [
          { networking.hostName = hostname; }
          (./. + "/hosts/${hostname}/system.nix")
          ./modules/system/adblock.nix
          (import ./overlays { inherit pkgs lib nixpkgs system unstable; })
          sops-nix.nixosModules.sops
          home.nixosModules.home-manager {
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
#              powercord-overlay.overlay
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
      desktop = mkSystem inputs.unstable "x86_64-linux"  "desktop";
        # Portable Laptop
      x240 = mkSystem inputs.unstable    "x86_64-linux"  "x240";
        # Desktop Laptop
      t440p = mkSystem inputs.unstable   "x86_64-linux"  "t440p";
        # Server
      rpi4 = mkSystem inputs.unstable    "aarch64-linux" "rpi4";
    };

  }; 

}

