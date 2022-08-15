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
      ./../../system/wifi.nix
      (import "${home-manager}/nixos")
      (import "${impermanence}/nixos.nix")
    ];

    # pi4 cpu core
  nix.settings.max-jobs = 4;

  powerManagement.cpuFreqGovernor = lib.mkForce "powersaver";

    # grub and pi4 bootloader
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkForce false;
    generic-extlinux-compatible.enable = true;
    grub.enable = lib.mkForce false;
  };

    # network
  networking = {
    hostName = "nas";
    networkmanager.enable= false;
    enableIPv6 = false;
    useDHCP = false;
    nameservers = [ "94.140.14.14" "94.140.15.15" ];
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless.enable = true;
    wireless.interfaces = [ "wlan0" ];
    nat = {
      enable = true;
      externalInterface = "wlan0";
    };
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/root"
      "/etc/nixos"
      "/srv"
      "/var/lib"
      "/var/log"
      "/home"
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
