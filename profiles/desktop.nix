{ config, pkgs, lib, ... }: {

  imports = [
    ./common.nix
    ../system/fonts.nix
    ../system/security.nix
    ../modules/audio.nix
    ../modules/bluetooth.nix
    ../users/binette.nix
    ../users/cath.nix
    ../users/shared.nix
  ];

    services.xserver = {
      enable = true;
        # enable startx
      displayManager.startx.enable = true;
        # enable suckless window manager
      windowManager.dwm.enable =true;
        # enable plasma desktop environment
      desktopManager.plasma5.enable = true;
        # disable xterm session
      desktopManager.xterm.enable = false;
    };

  programs.chromium = {
    enable = true;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q=%s";
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "cimiefiiaegbelhefglklhhakcgmhkai" # plasma integration
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
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
    brave
    chromium
    vieb
    nur.repos.sikmir.librewolf
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
    neovim
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
