{
  description = "Binette's NixOS Configuration";

  /* --- System's Inputs--- */
  inputs = {
    /* --- Default Nixpkgs --- */
    nixpkgs.follows = "stable";

    /* --- Nixpkgs branches --- */
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    /* --- Others --- */
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "github:nix-community/home-manager/release-24.11";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";
    plasma-manager.url = "github:pjones/plasma-manager";
    nix-colors.url = "github:misterio77/nix-colors";
    helix.url = "github:SoraTenshi/helix/experimental-22.12";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS/development";
    autorandr = { url = "github:phillipberndt/autorandr"; flake = false; };
    nixvim.url = "github:nix-community/nixvim";

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
    home.inputs.nixpkgs.follows = "stable";
    nix-gaming.inputs.nixpkgs.follows = "stable";
    sops-nix.inputs.nixpkgs.follows = "stable";
    plasma-manager.inputs = { nixpkgs.follows = "stable"; home-manager.follows = "home"; };
  };

  /* ---System's Output--- */
  outputs = {
    self,
    nixpkgs,
    unstable,
    stable,
    nixos-hardware,
    nix-colors,
    ...
  }@inputs:
  let
    inherit (import ./lib/attrsets.nix { inherit (nixpkgs) lib; }) recursiveMergeAttrs;
    inherit (import ./lib/mkSystem.nix inputs) mkNixOSConfig mkHomeConfig;
  in
    (recursiveMergeAttrs [

      /* ---Defining Systems--- */
        # Main Desktop
      (mkNixOSConfig { hostname = "desktop"; })
        # Desktop Server
      (mkNixOSConfig { hostname = "desktop-server"; })
        # Steamdeck
      (mkNixOSConfig {
        hostname = "decky";
        system = "x86_64-linux";
        nixosSystem = unstable.lib.nixosSystem;
      })
        # Lenovo Thinkpad x240
      (mkNixOSConfig { hostname = "x240"; })
        # Lenovo Thinkpad t440p
      (mkNixOSConfig { hostname = "t440p"; })
        # Raspberry Pi 4
      (mkNixOSConfig { hostname = "rpi4"; system = "aarch64-linux"; })

      /* ---Defining Home-Manager--- */
      (mkHomeConfig { hostname = "desktop"; })
      (mkHomeConfig {
        hostname = "minimal";
        configuration = ./home-manager/minimal.nix;
      })
      (mkHomeConfig {
        hostname = "laptop";
        configuration = ./home-manager/laptop.nix;
      })
      (mkHomeConfig {
        hostname = "server";
        configuration = ./home-manager/server.nix;
      })
    ]);

}
