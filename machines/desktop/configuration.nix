#!/run/current-system/sw/bin/nix
{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
  {

    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./../../profiles/common.nix
        ./../../profiles/communication.nix
        ./../../profiles/desktop.nix
        ./../../profiles/gaming.nix
        ./../../modules/amd/cpu.nix
        ./../../modules/amd/gpu.nix
        (import "${home-manager}/nixos")
      ];

    # ryzen 5 3600
  nix.maxJobs = 12;

#  services.syncthing = {
#    user = "binette";
#    dataDir = "/home/binette/.config/syncthing";
#  };

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
  boot.loader.grub = {
    gfxmodeEfi = "2560x1440";
    configurationName = "Gaming";
    useOSProber = true;
      # Index of the default menu item to be booted
    default = 4;
  };

    # networking
  networking = {
    hostName = "bin-desktop";
    enableIPv6 = false;
    useDHCP = false;
    nameservers = [ "94.140.14.14" "94.140.15.15" ];
    wireless.enable = false;
    networkmanager.enable = true;

      # firewall
    firewall = {
      enable = lib.mkForce true;
      trustedInterfaces = [ "tailscale0" ];
    };
  };

    # performance stuff
  powerManagement.cpuFreqGovernor = "performance";
  programs.gamemode.enable = true;

    # SSD STUFF
    # swap ram when % bellow is reach (1-100)
  boot.kernel.sysctl = { "vm.swappiness" = 1; };
  services.fstrim.enable = true; # ssd trimming

  environment.systemPackages = with pkgs; [ os-prober ];

  environment.persistence."/nix/persist" = {
    directories = [
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


  system.stateVersion = "21.11";

}
