{ config, lib, pkgs, super, ... }: {

  options.modules.hm.gaming = {
    enable = lib.mkOption {
      description = "Enable gaming related configuration";
      default = false;
    };
  };

  config.home.packages = with pkgs; lib.mkMerge [
    ([
      bat
        cron
      curl
      eza
      fzf
#      gcc
#      gnumake
      gnused
      htop
      killall
      ncdu
      ouch #easily compressing and decompressing files and directories
      rsync # replace scp
      wget
      yt-dlp
  
      # Archive tools
      atool
      zip
      unzip
      rar
    ])

    (lib.mkIf super.services.xserver.windowManager.qtile.enable [
      discord
      texlive.combined.scheme-full
      grim
      slurp
      pamixer
      pulsemixer
      wl-clipboard
      wlr-randr
      vimiv-qt
      waylock
      rofi-wayland
      mupdf
      newsboat
      udiskie
      zathura
    ])

    (lib.mkIf config.modules.hm.gaming.enable [
      # Games
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
  ];

}

