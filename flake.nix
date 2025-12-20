{
  description = "Binette's NixOS Configuration";

  # --- System's Inputs---
  inputs = {
    # --- Default Nixpkgs ---
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # --- Nixpkgs branches ---
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ---Games---
    games.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ---Tools---
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/main";
    impermanence.url = "github:nix-community/impermanence";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS/development";
    yeetmouse.url = "github:binettexyz/YeetMouse?dir=nix";
  };

  # ---System's Output---
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (import ./lib/attrsets.nix { inherit (nixpkgs) lib; }) recursiveMergeAttrs;
      inherit (import ./lib/mkSystem.nix inputs) mkNixOSConfig mkHomeConfig;
    in
    (recursiveMergeAttrs [
      # ---Defining Systems---
      (mkNixOSConfig {
        # Steam Machine
        hostname = "suzaku"; # Zhuque / Vermilion Bird
        extraMods = [ ./modules/presets/gaming-console.nix ];
      })
      (mkNixOSConfig {
        # Steamdeck
        hostname = "seiryu"; # Qinglong / Azure Dragon
        extraMods = [ ./modules/presets/gaming-console.nix ];
      })
      (mkNixOSConfig {
        # Thinkpad T480
        hostname = "byakko"; # Baihu / White Tiger
        extraMods = [ ./modules/presets/laptop.nix ];
      })
      (mkNixOSConfig {
        # Thinkpad T440
        hostname = "kei"; # Kui / Legs
        extraMods = [ ./modules/presets/laptop.nix ];
      })
      (mkNixOSConfig {
        # Raspberry Pi 4
        hostname = "genbu"; # Xuanwu / Black Turtoise
        system = "aarch64-linux";
        extraMods = [ ./modules/presets/homelab.nix ];
      })

      # ---Defining Home-Manager---
      (mkHomeConfig {
        hostname = "linux";
      })
    ]);
}
