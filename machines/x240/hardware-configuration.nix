#!/bin/nix
{ config, lib, pkgs, modulesPath, ... }:

{
        imports = [
                (modulesPath + "/installer/scan/not-detected.nix")
        ];

          # kernel modules/packages
        boot = {
                  # acpi_call makes tlp work for newer thinkpads
                extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
                kernelModules = [];
                kernelPackages = pkgs.linuxPackages_latest;
                kernelParams = [];
                initrd = {
                        availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
                        kernelModules = [ "acpi_call" ];
                };
        };

          # trackpad
        services.xserver.libinput.enable = true;
        services.xserver.libinput.touchpad = {
                naturalScrolling = true;
                tapping = true;
                disableWhileTyping = true;
                middleEmulation = true;
        };

          # trackpoint
        hardware.trackpoint = {
                enable = true;
                sensitivity = 300;
                speed = 100;
                emulateWheel = false;
        };

        fileSystems = {
                "/" = {
                        device = "none";
                        fsType = "tmpfs";
                        options = [ "defaults" "size=2G" "mode=755" ];
                };
                "/boot" = {
                        device = "/dev/disk/by-uuid/777A-EEA1";
                        fsType = "vfat";
                };
                "/nix" = {
                        device = "/dev/disk/by-uuid/c1aa747e-6ced-444e-8084-5c7810144bd9";
                        fsType = "ext4";
                };
                "/nix/persist/home" = {
                        device = "/dev/disk/by-label/home";
                        fsType = "ext4";
                };
                "/home/media/ventoy" = {
                        device = "/dev/disk/by-label/Ventoy";
                        fsType = "exfat";
                        options = [ "defaults" ];
                };
        };

        swapDevices = [{ device = "/dev/disk/by-uuid/a0c6bce5-ed75-4258-824a-0b08941e4100"; }];

}
