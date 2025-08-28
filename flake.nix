{
  description = "Binette's NixOS Configuration";

  # --- System's Inputs---
  inputs = {
    # --- Default Nixpkgs ---
    nixpkgs.follows = "unstable";

    # --- Nixpkgs branches ---
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # --- Others ---
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "github:nix-community/home-manager/master";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-gaming.url = "github:fufexan/nix-gaming";
    plasma-manager.url = "github:nix-community/plasma-manager";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-colors.url = "github:misterio77/nix-colors";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS/development";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # --- Minimize duplicate instances of inputs ---
    home.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    jovian-nixos.follows = "chaotic/jovian";
  };

  # ---System's Output---
  outputs = {
    self,
    nixpkgs,
    unstable,
    stable,
    nixos-hardware,
    nix-colors,
    ...
  } @ inputs: let
    inherit (import ./lib/attrsets.nix {inherit (nixpkgs) lib;}) recursiveMergeAttrs;
    inherit (import ./lib/mkSystem.nix inputs) mkNixOSConfig mkHomeConfig;
  in (recursiveMergeAttrs [
    # ---Defining Systems---
    # Gaming Desktop (Azure Dragon)
    (mkNixOSConfig {
      deviceType = "desktop";
      deviceTags = ["workstation" "gaming" "highSpec"];
      gpuType = "amdgpu";
      hostname = "seiryu";
      extraMods = [
        ./modules/presets/gaming-desktop.nix
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.chaotic.nixosModules.default
      ];
    })
    # Steamdeck (Torpedo)
    (mkNixOSConfig {
      deviceType = "handheld";
      deviceTags = ["battery" "gaming" "lowSpec" "steamdeck" "touchscreen"];
      gpuType = "amdgpu";
      hostname = "gyorai";
      extraMods = [
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.jovian-nixos.nixosModules.jovian
        inputs.chaotic.nixosModules.default
      ];
    })
    # Lenovo Thinkpad t480 (Swift Wind)
    (mkNixOSConfig {
      deviceType = "laptop";
      deviceTags = ["workstation" "dev" "battery" "lowSpec"];
      hostname = "hayate";
    })
    # Lenovo Thinkpad t440p (Heart/Spirit)
    (mkNixOSConfig {
      deviceType = "laptop";
      deviceTags = ["workstation" "battery" "lowSpec"];
      hostname = "kokoro";
    })
    # Raspberry Pi 4 (Shadow Darkness)
    (mkNixOSConfig {
      deviceType = "server";
      hostname = "kageyami";
      system = "aarch64-linux";
    })

    # ---Defining Home-Manager---
    (mkHomeConfig {
      deviceType = "gaming-desktop";
      hostname = "seiryu";
    })
  ]);
}
