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
    vintage-story.url = "github:NixOS/nixpkgs/7b04f942cf745f4e43ce772a692b68bdd1315524";

    # ---Tools---
    home.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-gaming.url = "github:fufexan/nix-gaming";
    plasma-manager.url = "github:nix-community/plasma-manager";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-colors.url = "github:misterio77/nix-colors";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS/development";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    yeetmouse.url = "github:binettexyz/YeetMouse?dir=nix";

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
    (mkNixOSConfig { # Steam Machine
      deviceType = "desktop";
      deviceTags = ["console" "gaming" "highSpec" "workstation"];
      gpuType = "amdgpu";
      hostname = "suzaku"; # Zhuque / Vermilion Bird
      extraMods = [
        ./modules/presets/gaming-console.nix
        inputs.yeetmouse.nixosModules.default
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.chaotic.nixosModules.default
        inputs.jovian-nixos.nixosModules.jovian
      ];
    })
    (mkNixOSConfig { # Steamdeck
      deviceType = "handheld";
      deviceTags = ["battery" "console" "gaming" "lowSpec" "steamdeck" "touchscreen"];
      gpuType = "amdgpu";
      hostname = "seiryu"; # Qinglong / Azure Dragon
      extraMods = [
        ./modules/presets/gaming-console.nix
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.jovian-nixos.nixosModules.jovian
        inputs.chaotic.nixosModules.default
      ];
    })
    (mkNixOSConfig { # Thinkpad T480
      deviceType = "laptop";
      deviceTags = ["workstation" "dev" "battery" "lowSpec"];
      hostname = "byakko"; # Baihu / White Tiger
      extraMods = [./modules/presets/laptop.nix];
    })
    (mkNixOSConfig { # Thinkpad T440
      deviceType = "laptop";
      deviceTags = ["workstation" "battery" "lowSpec"];
      hostname = "kei"; # Kui / Legs
      extraMods = [./modules/presets/laptop.nix];
    })
    (mkNixOSConfig { # Raspberry Pi 4
      deviceType = "server";
      hostname = "genbu"; # Xuanwu / Black Turtoise
      system = "aarch64-linux";
      extraMods = [./modules/presets/server.nix];
    })

    # ---Defining Home-Manager---
    (mkHomeConfig {
      deviceType = "gaming-desktop";
      hostname = "seiryu";
    })
  ]);
}
