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
                kernelModules = [ "kvm-intel" ];
                kernelPackages = pkgs.linuxPackages_latest;
                kernelParams = [];
                initrd = {
                        availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
                        kernelModules = [ "i915" "acpi_call" ];
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
                  device = "/dev/disk/by-label/boot";
                  fsType = "vfat";
                };
                "/nix" = {
                  device = "/dev/disk/by-label/nix";
                  fsType = "ext4";
                };
                "/nix/persist/home" = {
                  device = "/dev/disk/by-label/home";
                  fsType = "ext4";
                };
                "/mounts/nas" = {
                  device = "100.71.254.90:/media";
                  fsType = "nfs";
                    # don't freeze system if mount point not available on boot
                  options = [ "x-systemd.automount" "noauto" ];
                };

        };

        swapDevices = [{ device = "/dev/disk/by-uuid/a0c6bce5-ed75-4258-824a-0b08941e4100"; }];

          # cpu
        hardware.cpu.intel.updateMicrocode = true;
        services.throttled.enable = false;

          # igpu
        services.xserver.videoDrivers = [ "intel" ];
        hardware.enableRedistributableFirmware = true;
        hardware.opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
          extraPackages = with pkgs; [
            vaapiIntel
            vaapiVdpau
            libvdpau-va-gl
            intel-media-driver
          ];
        };

}
