{ pkgs, ... }:{

  home.packages = with pkgs; [
    # Games
    prismlauncher
    shattered-pixel-dungeon
    # Launcher/Tools
    heroic
  ];

}

