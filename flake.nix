{
  description = "Binette's NixOS Configuration";

  /* --- System's Inputs--- */
  inputs = {
    /* --- Default Nixpkgs --- */
    nixpkgs.follows = "master";

    /* --- Nixpkgs branches --- */
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    /* --- Others --- */
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "github:nix-community/home-manager/master";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";
    plasma-manager.url = "github:pjones/plasma-manager";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:SoraTenshi/helix/experimental-22.12";
    jovian = { url = "github:Jovian-Experiments/Jovian-NixOS/development"; flake = false; };

    /* --- Suckless Software --- */
    dwm = { url = "github:binettexyz/dwm"; flake = false; };
    st = { url = "github:binettexyz/st"; flake = false; };
    dmenu = { url = "github:binettexyz/dmenu"; flake = false; };

    /* --- Discord stuff --- */
    #powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    #disc-betterReplies = { url = "github:cyyynthia/better-replies"; flake = false; };
    #disc-doubleClickVC = { url = "github:discord-modifications/double-click-vc"; flake = false; };
    #disc-muteNewGuild = { url = "github:RazerMoon/muteNewGuild"; flake = false; };
    #disc-popoutFix = { url = "github:Nexure/PowerCord-Popout-Fix"; flake = false; };
    #disc-screenshareCrack = { url = "github:discord-modifications/screenshare-crack"; flake = false; };
    #disc-unindent = { url = "github:VenPlugs/Unindent"; flake = false; };
    #disc-silentTyping = { url = "github:svby/powercord-silenttyping"; flake = false; };
    #disc-gruvbox = { url = "github:binettexyz/discord-gruvbox"; flake = false; };

    /* --- Minimize duplicate instances of inputs --- */
    home.inputs.nixpkgs.follows = "unstable";
    nix-gaming.inputs.nixpkgs.follows = "unstable";
    sops-nix.inputs.nixpkgs.follows = "unstable";
    plasma-manager.inputs = { nixpkgs.follows = "unstable"; home-manager.follows = "home"; };
  };

  /* ---System's Output--- */
  outputs = {
    self,
    nixpkgs,
    unstable,
    nixos-hardware,
    nix-colors,
    ...
  }@inputs:
  let
    lib = nixpkgs.lib;

    mkSystem = { name, pkgs ? "inputs.unstable", system ? "x86_64-linux", extraMods ? [], extraOverlays ? [] }: ( lib.nixosSystem {
      inherit system;
        specialArgs = { inherit inputs nix-colors; };
        modules = [
          ./hosts/${name}/config.nix
          ./shared/adblock.nix
          { networking.hostName = name; }
          (import ./overlays { inherit inputs lib nixpkgs system pkgs unstable; }) 

          inputs.home.nixosModules.home-manager {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs nix-colors; };
              users.binette = (./. + "/hosts/${name}/user.nix");
            };
            nixpkgs.overlays = [ /* powercord-overlay.overlay nur.overlay */ ];
          }
        ] ++ extraMods;
      });
  in {

    /* ---Defining Systems--- */
    nixosConfigurations.desktop = mkSystem {
      name = "desktop";
      extraMods = [
        inputs.sops-nix.nixosModules.sops
        inputs.impermanence.nixosModules.impermanence 
        #inputs.nix-gaming.nixosModules.pipewireLowLatency 
      ];
      extraOverlays = [];
    };

    nixosConfigurations.steamdeck = mkSystem { 
      name = "decky";
      extraMods = [
        "${inputs.jovian}/modules"
        inputs.sops-nix.nixosModules.sops
        #inputs.nix-gaming.nixosModules.pipewireLowLatency 
      ];
      extraOverlays = [];
      pkgs = "stable";
    };

    nixosConfigurations.x240 = mkSystem {
      name = "x240";
      extraMods = [
        inputs.sops-nix.nixosModules.sops
        inputs.impermanence.nixosModules.impermanence 
      ];
      extraOverlays = [];
    };

    nixosConfigurations.t440p = mkSystem {
      name = "t440p";
      extraMods = [
        inputs.sops-nix.nixosModules.sops
        inputs.impermanence.nixosModules.impermanence
      ];
      extraOverlays = [];
    };

    nixosConfigurations.rpi4 = mkSystem {
      name = "rpi4";
      extraMods = [
        inputs.sops-nix.nixosModules.sops
        inputs.impermanence.nixosModules.impermanence
      ];
      extraOverlays = [];
      system = "aarch64-linux";
    };

    images = {
      rpi4 =
        (self.nixosConfigurations.rpi4.extendModules {
          modules = ["${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];
        })
        .config
        .system
        .build
        .sdImage;
    };
  }; 

}

