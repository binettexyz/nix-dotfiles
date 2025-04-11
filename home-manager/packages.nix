{
  config,
  lib,
  pkgs,
  super,
  ...
}:
{

  config.home.packages =
    with pkgs;
    lib.mkMerge [
      ([
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
      ])

      (lib.mkIf config.modules.hm.gui.packages [
        discord
        libreoffice
        texlive.combined.scheme-full
      ])

      (lib.mkIf super.services.xserver.windowManager.qtile.enable [
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
