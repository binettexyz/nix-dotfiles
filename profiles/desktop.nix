{ config, pkgs, lib, ... }: {

  imports = [
    ./common.nix
    ../profiles/devs.nix
    ../modules/pipewire
    ../modules/bluetooth
    ../services/x/greenclip.nix
    ../services/net/printer.nix
    ../users/binette
  ];

  services.xserver = {
    enable = true;
      # enable startx
    displayManager.startx.enable = true;
      # enable suckless window manager
    windowManager.dwm.enable =true;
      # enable plasma desktop environment
    desktopManager.plasma5.enable = false;
      # disable xterm session
    desktopManager.xterm.enable = false;
  };

  # silent boot
  boot.consoleLogLevel = 1;
  boot.kernelParams = [
    "quiet" "splash" "vga=current" "i915.fastboot=1"
    "loglevel=3" "systemd.show_status=auto" "udev.log_priority=3"
  ];

    # install packages
  environment.systemPackages = with pkgs; [
      # suckless
    dwm-head
    st-head
    dmenu-head
    slstatus-head
      # browser
    unstable.librewolf
#    qutebrowser
#    vieb
      # programming language
#    unstable.python3
      # system
    xorg.xinit
    xorg.xev
    xorg.xmodmap
    xdotool
    maim
    slop
    xclip
    hsetroot
    udiskie
    unclutter-xfixes
    dunst
    libnotify
    seturgent
    redshift
    ffmpeg
    xcape
      # virtualisation
#    virt-manager
      # media
    mpv
    nsxiv
    playerctl
      # text
    zathura
    mupdf
#    texlive.combined.scheme-full
      # rss
    newsboat
      # audio mixer
    pulsemixer
    unstable.pamixer
      # graphical tools
    pcmanfm
      # logitech device manager
#    solaar

    nodejs
  ];

}
