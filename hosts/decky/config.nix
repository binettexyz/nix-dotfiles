{ config, flake, lib, pkgs, system, ... }:

{
  imports = [
    ./hardware.nix
    flake.inputs.jovian-nixos.nixosModules.jovian
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  jovian.steam = {
    enable = true;
    user = "binette";
    desktopSession = "gnome";
    autoStart = true;
    
  };

  jovian.devices.steamdeck = {
    enable = true;
    autoUpdate = true;
    
  };

  jovian.decky-loader = {
    enable = true;
    user = "binette";
    
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
#  services.xserver.videoDrivers = [ "amdgpu" ];

  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.binette = {
    isNormalUser = true;
    description = "Jonathan Binette";
    extraGroups = [ "networkmanager" "wheel" "users" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    jupiter-dock-updater-bin
    steamdeck-firmware
    lf
    vim
    git
  ];

   services.openssh.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ]

}
