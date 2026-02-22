{
  flake.nixosModules.locale = {
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_CTYPE = "en_US.UTF-8"; # Fix ç in us-intl.
      LC_TIME = "en_CA.UTF-8";
    };
    # Set TTY font and keyboard layout.
    console.font = "Lat2-Terminus16";
    console.keyMap = "us";

    # Set your time zone.
    time.timeZone = "Canada/Eastern";
    services.timesyncd.enable = true;
    location = {
      provider = "manual";
      latitude = 45.53;
      longitude = -73.62;
    };
  };
}
