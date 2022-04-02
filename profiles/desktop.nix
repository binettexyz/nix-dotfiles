{ config, pkgs, lib, ... }: {

  imports = [
    ./common.nix
    ../modules/audio.nix
    ../modules/bluetooth.nix
    ../services/x/greenclip.nix
    ../users
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

  programs.chromium = {
    enable = false;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q=%s";
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "cimiefiiaegbelhefglklhhakcgmhkai" # plasma integration
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
#      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    ];
      # See available options at https://chromeenterprise.google/policies/
    extraOpts = {
      "BrowserSignin" = 0;
      "BrowserAddPersonEnabled" = false;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "BuiltInDnsClientEnabled" = false;
      "MetricsReportingEnabled" = false;
      "SearchSuggestEnabled" = false;
      "AlternateErrorPagesEnabled" = false;
      "UrlKeyedAnonymizedDataCollectionEnabled" = false;
      "SpellcheckEnabled" = false;
      "CloudPrintSubmitEnabled" = false;
      "BlockThirdPartyCookies" = true;
      "AutoplayAllowed" = false;
      "HomepageIsNewTabPage" = false;
    };
  };

    # install packages
  environment.systemPackages = with pkgs; [
      # suckless
    dwm-head
    st-head
    dmenu-head
    slstatus-head
      # browser
    brave play-with-mpv
#    chromium
#    vieb
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
    twmn
    redshift
      # media
    mpv
    sxiv
    playerctl
      # text
    zathura
    mupdf
    texlive.combined.scheme-full
      # rss
    newsboat
      # audio mixer
    pulsemixer
    unstable.pamixer
      # graphical tools
    pcmanfm
  ];

}
