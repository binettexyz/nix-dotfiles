#!/bin/nix
{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in {

  imports =
    [
      ./hardware-configuration.nix
      ./../../profiles/common.nix
      ./../../profiles/server.nix
      ./../../modules/pi4/gpu.nix
      ./../../services/net/wifi.nix
      (import "${home-manager}/nixos")
      (import "${impermanence}/nixos.nix")
    ];

    # pi4 cpu core
  nix.maxJobs = 4;

  powerManagement.cpuFreqGovernor = lib.mkForce "powersaver";

    # auto login user on startup
  services.getty.autologinUser = "server";

    # grub and pi4 bootloader
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader = {
    generic-extlinux-compatible.enable = true;
    raspberryPi = {
      enable = true;
      version = 4;
    };
    grub = {
      enable = false;
    };
  };

    # network
  networking = {
    hostName = "bin-server";
    networkmanager.enable= false;
    enableIPv6 = false;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
      # static ip
#    defaultGateway = "192.168.1.255"; # Router gateway IP
#    nameservers = [ "8.8.8.8" ];
#    interfaces.eth0.ipv4.addresses = [{ # Static IP
#      address = "192.168.1.129";
#      prefixLength = 24;
#    }];

      # firewall
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
        # TCP ports on which incoming connections are accepted.
#      allowedTCPPorts =
#        [
#          22 # ssh
#          9091 # transmission
#          9117 # jackett
#          8989 # sonarr
#          7878 # radarr
#          3000 # adguard home
#          5432 # miniflux
#        ];
    };
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/srv"
      "/var/lib"
      "/var/log"
    ];
  };

  environment.etc = {
    "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
  };

  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

  system.stateVersion = "22.05";
}
