{
  description = "Binette's NixOS Configuration";

  /* --- System's Inputs--- */
  inputs = {
    /* --- Default Nixpkgs --- */
    nixpkgs.follows = "master";

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
    plasma-manager.url = "github:pjones/plasma-manager";

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
    plasma-manager.inputs = { nixpkgs.follows = "unstable"; home-manager.follows = "home"; };
  };

  /* ---System's Output--- */
  outputs = {
    self,
    nixpkgs,
    unstable,
    nixos-hardware,
    ...
  }@inputs:
  let
    mkSystem = import ./lib/mkSystem.nix;
    system = "x86_64-linux"; # current system
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    lib = nixpkgs.lib;
  in
    {
      /* ---Defining Systems--- */
      nixosConfigurations = {
          # Main Desktop
        desktop = mkSystem "desktop" {
          inherit inputs unstable lib;
          system = "x86_64-linux";
          nixpkgs = inputs.unstable;
          modules = [ ];
        };
          # Lenovo Thinkpad x240
        x240 = mkSystem "x240" {
          inherit inputs unstable lib;
          system = "x86_64-linux";
          nixpkgs = inputs.unstable;
          modules = [ ];
        };
          # Lenovo Thinkpad t440p
        t440p = mkSystem "t440p" {
          inherit inputs unstable lib;
          system = "x86_64-linux";
          nixpkgs = inputs.unstable;
          modules = [ ];
        };
          # Raspberry Pi 4
        rpi4 = mkSystem "rpi4" {
          inherit inputs unstable lib;
          system = "aarch64-linux";
          nixpkgs = inputs.unstable;
          modules = [ ];
        };
      };
    }; 

}

