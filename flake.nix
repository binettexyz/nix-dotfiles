{
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    };

  inputs = {
    # --- Default Nixpkgs ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Nixpkgs banches ---
    stable.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Games ---
    vintagestory.url = "github:NixOS/nixpkgs/nixos-unstable";
    steam.url = "github:NixOS/nixpkgs/nixos-unstable";
    prismlauncher.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ---Hyprland---
    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    # --- Tools ---
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    systems.url = "github:nix-systems/default";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS/development";
    yeetmouse.url = "github:binettexyz/YeetMouse?dir=nix";

  };
}
