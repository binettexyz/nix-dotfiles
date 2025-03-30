{ config, lib, pkgs, super, ... }:
let
  cliPackages = with pkgs; [
    bat
    cron
    curl
    eza
    fzf
#    gcc
#    gnumake
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
  ];

  guiPackages = with pkgs; [
    (lib.mkIf (builtins.elem config.device.type == [ "workstation" "gaming-desktop" ]) grim )
    (lib.mkIf (builtins.elem config.device.type == [ "workstation" "gaming-desktop" ]) texlive.combined.scheme-full )
    (lib.mkIf (builtins.elem config.device.type == [ "gaming-desktop" ]) discord )
    (lib.mkIf (builtins.elem config.device.type == [ "workstation" "gaming-desktop" ]) libreoffice )
    slurp
    wl-clipboard
    wlr-randr
    vimiv-qt
    waylock
    rofi-wayland
    mupdf
    newsboat
    pamixer
    pulsemixer
    udiskie
    zathura
  ];

  gamingPackages = with pkgs; [
    # Games
    prismlauncher
    gzdoom
    #zeroad

    # Launcher/tools
    heroic
    protonup-qt
    r2modman
    lutris
    wineWowPackages.waylandFull
    jdk
    dxvk
  ];

  isDE = super.services.xserver.windowManager.qtile.enable;
  isGaming = config.modules.hm.gaming.enable or false;
in {

  options.modules.hm.gaming = {
    enable = lib.mkOption {
      description = "Enable gaming related configuration";
      default = false;
    };
  };

  config = {
    home.packages = cliPackages
      ++ (if isDE then guiPackages else [])
      ++ (if isGaming then gamingPackages else []);
  };

  }

