{ config, ... }: {
      # Set your time zone.
    time.timeZone = "Canada/Eastern";
    location = {
      provider = "manual";
      latitude = 45.30;
      longitude = -73.35;
    };
      # english locales
    i18n.defaultLocale = "en_US.UTF-8";
      # us keyboard
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

}
