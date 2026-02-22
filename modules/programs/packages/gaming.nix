{
  flake.modules.homeManager.emulation =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.mgba # Gameboy Advance SP
        pkgs.cemu # Wii U
        pkgs.dolphin-emu # Wii
        #pkgs.dolphin-emu-primehack # Wii (Metroid Prime-specific fixes)
        pkgs.pcsx2 # PS2
        pkgs.ppsspp # PSP
        pkgs.rpcs3 # PS3
        pkgs.ryubing # Ryujinx fork with updated features
        pkgs.xemu # OG Xbox emulator
        pkgs.xenia-canary # Fork of Xenia, Xbox 360
        pkgs.ares # Multi-emulators
        pkgs.simple64 # n64
      ];
    };

  flake.modules.homeManager.games =
    { pkgs, ... }:
    {
      home.packages = [
        # Games
        pkgs.vintagestory
        pkgs.prismlauncher
        #pkgs.gzdoom
        #pkgs.zeroad

        # Launcher/Tools
        pkgs.heroic
        pkgs.protonup-qt
        pkgs.r2modman
        pkgs.lutris
        pkgs.wineWowPackages.waylandFull
        pkgs.jdk
        pkgs.dxvk
        pkgs.steamtinkerlaunch
        pkgs.vesktop
      ];
    };
}
