#!/run/current-system/sw/bin/nix
{ config, pkgs, ... }: {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/bin-server/audio.nix
      ./modules/bin-server/boot.nix
      ./modules/bin-server/fonts.nix
      ./modules/bin-server/network.nix
      ./modules/bin-server/packages.nix
      ./modules/bin-server/powerManagement.nix
      ./modules/bin-server/security.nix
      ./modules/bin-server/users.nix
      ./modules/bin-server/x11.nix
    ];

    # Set your time zone.
  time.timeZone = "Canada/Eastern";

    # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.etc.current-nixos-config.source = ./.;

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
  };

  system.stateVersion = "21.05";

}
