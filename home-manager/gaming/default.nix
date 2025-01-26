{ pkgs, flake, ... }:{

  imports = [ ./games_config ];

  home.packages = with pkgs; [
    # Games
    prismlauncher # Minecraft Launcher
    gzdoom # Modded doom
    celeste64 # Celeste with n64 engine
    #zeroad # Historical real-time strategy game

    # Launcher/Tools
    heroic # Launcher for epic/gog/amazon
    discord
    ripcord
    flake.inputs.nix-gaming.packages.${pkgs.system}.mo2installer
    protonup-qt # Download proton-ge.

    # Emulation
    # TODO: Add emulators
    steam-rom-manager # Tool to add roms to steam
  ];

}

