{ lib, ... }: {

    # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = lib.mkDefault "en_US.UTF-8"; # Fix ç in us-intl.
    LC_TIME = lib.mkDefault "en_CA.UTF-8";
  };
    # Set TTY font and keyboard layout.
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

    # Set your time zone.
  time.timeZone = lib.mkDefault "Canada/Eastern";
  location = {
    provider = "manual";
    latitude = 45.30;
    longitude = -73.35;
  };

}
