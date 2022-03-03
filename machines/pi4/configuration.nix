{ config, pkgs, lib, modulesPath, ... }:

let
home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {

     imports =
       [   # Include the results of the hardware scan.
         "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"
         (import "${home-manager}/nixos")
         (modulesPath + "/installer/scan/not-detected.nix")
       ];

       # kernel stuff
     boot = {
       kernelPackages = pkgs.linuxPackages_rpi4;
       initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
         # ttyAMA0 is the serial console broken out to the GPIO
       kernelParams = [
         "8250.nr_uarts=1"
         "console=ttyAMA0,115200"
         "console=tty1"
           # Some gui programs need this
         "cma=128M"
       ];
     };

       # pi4 cpu core
     nix.maxJobs = 4;

     powerManagement.cpuFreqGovernor = mkForce "powersaver";

       # auto login user on startup
     services.getty.autologinUser = "server";

       # grub and pi4 bootloader
     boot.loader.canTouchEfiVariables = lib.mkForce false;
     boot.loader = {
       generic-extlinux-compatible.enable = true;
       raspberryPi = {
         enable = true;
         version = 4;
       };
       grub = {
         enable = lib.mkForce false;
         efiSupport = lib.mkforce false;
         device = lib.mkForce "/dev/sda";
         configurationName = "nix server";
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
#   }];

       # firewall
       firewall = {
         enable = true;
         trustedInterfaces = [ "tailscale0" ];
           # TCP ports on which incoming connections are accepted.
#         allowedTCPPorts =
#           [
#             22 # ssh
#             9091 # transmission
#             9117 # jackett
#             8989 # sonarr
#             7878 # radarr
#             3000 # adguard home
#	     5432 # miniflux
#           ];
#       };
     };

       # fileSystem
     fileSystems."/" = {
       device = "/dev/disk/by-label/NIXOS_SD";
       fsType = "ext4";
     };

     fileSystems."/home/media/exthdd" = {
       device = "/dev/disk/by-label/exthdd";
       fsType = "ntfs";
       options = [ "rw" "uid=1001" "gid=100" ];
     };

     system.stateVersion = "22.05";
}
