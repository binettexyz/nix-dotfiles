{
  description = "Binette's NixOS Configuration";

    # System's Input
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = { url = "github:NixOS/nixos-hardware"; flake = false; };

    impermanence.url = "github:nix-community/impermanence";

#    nur = {
#      url = "github:nix-community/NUR";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

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

    # System's Output
  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
#    nur,
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
              powercord-overlay.overlay
#              nur.overlay
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
      rpi4 = mkSystem inputs.nixpkgs "aarch64-linux" "rpi4";
    };

    packages."x86_64-linux"."anime4k" = import ./modules/pkgs/anime4k { inherit (nixpkgs.legacyPackages."x86_64-linux") stdenvNoCC unzip fetchurl; };
  }; 

}

