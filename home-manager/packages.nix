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
#      pkgs.killall
#      pkgs.ncdu
#      pkgs.ouch # easily compressing and decompressing files and directories
#      pkgs.rsync # replace scp
#      pkgs.wget
#      pkgs.yt-dlp

      pkgs.capitaine-cursors-themed
    ]

    (lib.mkIf (lib.elem "workstation" deviceTags) [
      # https://wiki.archlinux.org/title/Discord#Mic_volume_keeps_lowering_when_Discord_is_active_using_Wireplumber
      pkgs.vesktop
    ])

    (lib.mkIf (lib.elem "dev" deviceTags) [
      pkgs.libreoffice
      pkgs.texlive.combined.scheme-full
      pkgs.xfce.thunar
      pkgs.calibre
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
      #pkgs.gzdoom # Doom
      #pkgs.openmw # TES: Morrowind
      pkgs.prismlauncher # Minecraft
      pkgs.vintagestory
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
    (lib.mkIf (config.modules.hm.gaming.enable && lib.elem "highSpec" deviceTags) [
      pkgs.moondeck-buddy
    ])
    (lib.mkIf (lib.elem "console" deviceTags && lib.elem "gaming" deviceTags) [
      # Emulation
    ])
  ];
}
