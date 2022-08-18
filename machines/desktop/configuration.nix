#!/run/current-system/sw/bin/nix
{ config, pkgs, lib, ... }:
  {
    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./persistence.nix
        ./packages.nix
        ./../../profiles/common.nix
        ./../../profiles/desktop.nix
        ./../../system/wifi.nix
         <home-manager/nixos>
         <impermanence/nixos.nix>

     ];

    # ryzen 7 5800x
  nix.settings.max-jobs = 16;

    # screen resolution
  services.xserver = {
    xrandrHeads = [
      { output = "DisplayPort-0";
        primary = true;
        monitorConfig = ''
            # 2560x1440 164.90 Hz (CVT) hsync: 261.86 kHz; pclk: 938.50 MHz
          Modeline "2560x1440_165.00"  938.50  2560 2792 3072 3584  1440 1443 1448 1588 -hsync +vsync
          Option "PreferredMode" "2560x1440_165.00"
          Option "Position" "0 0"
        '';
      }
    ];
  };

    # grub
  environment.systemPackages = with pkgs; [ os-prober ];
  boot.loader.grub = {
    gfxmodeEfi = "1280x720";
    configurationName = "Desktop";
    useOSProber = true;
  };

    # networking
  networking = {
    hostName = "desktop-nix";
    enableIPv6 = false;
    useDHCP = true;
    nameservers = [ "94.140.14.14" "94.140.15.15" ];
    networkmanager.enable = false;
    wireless = {
      enable = true;
      interfaces = [ "wlo1" ];
    };
  };

    # performance stuff
  powerManagement.cpuFreqGovernor = "performance";
  programs.gamemode.enable = true;

    # SSD STUFF
    # swap ram when % bellow is reach (1-100)
  boot.kernel.sysctl = { "vm.swappiness" = 1; };
  services.fstrim.enable = true; # ssd trimming

  environment.etc = {
    "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
  };

  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

  system.stateVersion = "22.05";

}
