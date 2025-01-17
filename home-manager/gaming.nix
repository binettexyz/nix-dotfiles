{ pkgs, flake, ... }:{

  home.packages = with pkgs; [
    # Games
    prismlauncher # Minecraft Launcher
    shattered-pixel-dungeon
    # Launcher/Tools
    heroic # Launcher for epic/gog/amazon
    steam-rom-manager
    discord
    flake.inputs.nix-gaming.packages.${pkgs.system}.mo2installer
    protonup-qt # Download proton-ge.
  ];

}

