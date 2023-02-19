{ lib, ... }:

{
    # Select internationalisation properties.
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE = lib.mkDefault "pt_BR.UTF-8"; # Fix ç in us-intl.
      LC_TIME = lib.mkDefault "pt_BR.UTF-8";
    };
  };
    # Set TTY font and keyboard layout.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

    # Set X11 keyboard layout.
  services.xserver = {
    layout = lib.mkDefault "us";
      # us international layout with dead key on AltGR
      # https://zuttobenkyou.wordpress.com/2011/08/24/xorg-using-the-us-international-altgr-intl-variant-keyboard-layout/
    xkbVariant = lib.mkDefault "altgr-intl";
    # Remap Caps Lock to Esc
    xkbOptions = lib.mkDefault "caps:escape";
  };

    # Set your time zone.
  time.timeZone = lib.mkDefault "Canada/Eastern";
  location = {
    provider = "manual";
    latitude = 45.30;
    longitude = -73.35;
  };

}
