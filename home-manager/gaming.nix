{ pkgs, flake, ... }:{

  home.packages = with pkgs; [
    # Games
    prismlauncher
    shattered-pixel-dungeon
    # Launcher/Tools
    heroic
    steam-rom-manager
    discord
    flake.inputs.nix-gaming.packages.${pkgs.system}.mo2installer
  ];

}

