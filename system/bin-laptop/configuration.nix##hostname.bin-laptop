{ config, pkgs, ... }: {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/audio.nix
      ./modules/boot.nix
      ./modules/fonts.nix
      ./modules/network.nix
      ./modules/packages.nix
      ./modules/powerManagement.nix
      ./modules/security.nix
      ./modules/users.nix
      ./modules/x11.nix
    ];

    # Set your time zone.
  time.timeZone = "Canada/Eastern";

    # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  hardware = {
    opengl.enable = true;
#    acpilight.enable = true;
  };

  environment.etc.current-nixos-config.source = ./.;

  system.stateVersion = "21.05";

}
