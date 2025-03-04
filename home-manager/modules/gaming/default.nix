{ pkgs, flake, ... }:{

  imports = [ ./games_config ];

  home.packages = with pkgs; [
    # Games
    prismlauncher # Minecraft Launcher
    gzdoom # Modded doom
    #zeroad # Historical real-time strategy game

    # Launcher/Tools
    heroic # Launcher for epic/gog/amazon
    protonup-qt # Download proton-ge.
    r2modman # Mods manager
    moonlight-qt
  ];

}

