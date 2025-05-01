{
  config,
  deviceType,
  deviceTags,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config.home.packages = with pkgs;
    lib.mkMerge [
      [
        bat
        cron
        curl
        eza
        fzf
        gnused
        htop
        killall
        ncdu
        ouch # easily compressing and decompressing files and directories
        rsync # replace scp
        wget
        yt-dlp

        # Archive tools
        atool
        zip
        unzip
        rar
        capitaine-cursors-themed
      ]

      (lib.mkIf (lib.elem "workstation" deviceTags) [
        libreoffice
        texlive.combined.scheme-full
      ])

      (lib.mkIf osConfig.programs.hyprland.enable [
        wf-recorder
        grim
        slurp
        pamixer
        pulsemixer
        cliphist
        wl-clipboard
        wlr-randr
        vimiv-qt
        waylock
        wofi
        mupdf
        newsboat
        udiskie
        zathura
      ])

      (lib.mkIf (lib.elem "gaming" deviceTags) [
        # Games
        openmw
        prismlauncher
        gzdoom
        #zeroad

        # Launcher/Tools
        heroic
        protonup-qt
        r2modman
        lutris
        wineWowPackages.waylandFull
        jdk
        dxvk
      ])
      (lib.mkIf (config.modules.hm.gaming.enable && deviceType == "desktop") [
        moondeck-buddy
        vesktop
      ])
      (lib.mkIf (deviceType == "handheld" && lib.elem "gaming" deviceTags) [
        # Emulation
      ])
    ];
}
