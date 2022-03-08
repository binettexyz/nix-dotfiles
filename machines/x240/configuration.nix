#!/run/current-system/sw/bin/nix
{ config, pkgs, lib, ... }:
let
  user = "binette";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
  {

    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./touchpad.nix
        ./../../profiles/common.nix
        ./../../profiles/communication.nix
        ./../../profiles/desktop.nix
        ./../../profiles/laptop.nix
        ./../../services/net/wifi.nix
        ./../../modules/intel/cpu.nix
        ./../../modules/intel/igpu.nix
        (import "${home-manager}/nixos")
        (import "${impermanence}/nixos.nix")
      ];

      # x240 cpu cores
    nix.maxJobs = 4;

  services.syncthing = {
    user = "binette";
    dataDir = "/nix/persist/home/binette/.config/syncthing";
  };

      # screen resolution
    services.xserver = {
      xrandrHeads = [{
        output = "eDP1";
        primary = true;
        monitorConfig = ''
          Modeline "1368x768_60.11"   85.50  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
          Option "PreferredMode" "1366x768_60.11"
          Option "Position" "0 0"
        '';
      }];
    };
      # grub
    boot.loader.grub = {
      gfxmodeEfi = "1366x768";
      configurationName = "Lenovo thinkpad X240";
    };

      # network
    networking = {
      hostName = "bin-x240";
      enableIPv6 = false;
      useDHCP = false;
      nameservers = [ "94.140.14.14" "94.140.15.15" ];
      interfaces.wlp3s0.useDHCP = true;
      wireless = {
        enable = true;
        interfaces =  [ "wlp3s0" ];
      };

        # firewall
      firewall = {
        enable = lib.mkForce true;
        trustedInterfaces = [ "tailscale0" ];
      };
    };

      # SSD STUFF
      # swap ram when % bellow is reach (1-100)
    boot.kernel.sysctl = { "vm.swappiness" = 1; };
    services.fstrim.enable = true; # ssd trimming

      # Set environment variables
#    environment.variables = {
#      NIXOS_CONFIG="$HOME/.git/repos/.nixos/machines/x240/configuration.nix";
#      NIXOS_CONFIG_DIR="$HOME/.git/repos/.nixos/machines/x240/";
#    };

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
