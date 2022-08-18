#!/bin/nix
{ config, lib, pkgs, ... }:

{

        imports = [
                  # Include the results of the hardware scan.
                ./hardware-configuration.nix
                ./packages.nix
                ./../../profiles/desktop.nix
                ./../../profiles/laptop.nix
                ./../../system/wifi.nix
                <home-manager/nixos>
                <impermanence/nixos.nix>
        ];

          ### x240 cpu cores
        nix.settings.max-jobs = 4;

          ### screen resolution
        services.xserver = {
          xrandrHeads = [
            {
              output = "eDP1";
              primary = true;
              monitorConfig = ''
                Modeline "1368x768_60.11"   85.50  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
                Option "PreferredMode" "1366x768_60.11"
                Option "Position" "0 0"
                DisplaySize 276 156
              '';
            }

          ];
        };

          ### grub
        boot.loader.grub = {
                gfxmodeEfi = "1366x768";
        };

          ### network
        networking = {
                hostName = "x240";
                enableIPv6 = false;
                useDHCP = false;
                nameservers = [ "94.140.14.14" "94.140.15.15" ];
                interfaces.wlan0.useDHCP = true;
                interfaces.enp0s25.useDHCP = true;
                wireless = {
                        enable = true;
                        interfaces =  [ "wlan0" ];
                };
        };

          # SSD STUFF
          # swap ram when % bellow is reach (1-100)
        boot.kernel.sysctl = { "vm.swappiness" = 1; };
        services.fstrim.enable = true; # ssd trimming

        environment.persistence."/nix/persist" = {
                directories = [
                        "/etc/nixos"
                        "/srv"
                        "/var/lib"
                        "/var/log"
                        "/root"
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
