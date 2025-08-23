{
  config,
  deviceType,
  deviceTags,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config.home.packages = lib.mkMerge [
    [
      pkgs.bat
      pkgs.cron
      pkgs.curl
      pkgs.eza
      pkgs.fzf
      pkgs.gcc
      pkgs.gnused
      pkgs.htop
      pkgs.killall
      pkgs.ncdu
      pkgs.ouch # easily compressing and decompressing files and directories
      pkgs.rsync # replace scp
      pkgs.wget
      pkgs.yt-dlp

      pkgs.capitaine-cursors-themed
    ]

    (lib.mkIf (lib.elem "workstation" deviceTags) [
      pkgs.libreoffice
      pkgs.texlive.combined.scheme-full
    ])

    (lib.mkIf osConfig.programs.hyprland.enable [
      pkgs.wf-recorder
      pkgs.grim
      pkgs.slurp
      pkgs.pamixer
      pkgs.pulsemixer
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.wtype # Simulate keyboard inputs
      pkgs.zenity # Prompt
      pkgs.wlr-randr
      pkgs.vimiv-qt
      pkgs.waylock
      pkgs.wofi
      pkgs.mupdf
      pkgs.udiskie
      pkgs.zathura
    ])

    (lib.mkIf (lib.elem "gaming" deviceTags) [
      # Games
      #pkgs.openmw # TES: Morrowind
      pkgs.prismlauncher # Minecraft
      #pkgs.gzdoom # Doom
      #pkgs.zeroad # 0 a.d.

      # Launcher/Tools
      pkgs.heroic
      pkgs.protonup-qt
      pkgs.r2modman
      pkgs.lutris
      pkgs.wineWowPackages.waylandFull
      pkgs.jdk
      pkgs.dxvk
      pkgs.steamtinkerlaunch
    ])
    (lib.mkIf (config.modules.hm.gaming.enable && deviceType == "desktop") [
      pkgs.moondeck-buddy
      pkgs.vesktop
    ])
    (lib.mkIf (deviceType == "handheld" && lib.elem "gaming" deviceTags) [
      # Emulation
    ])
  ];
}
