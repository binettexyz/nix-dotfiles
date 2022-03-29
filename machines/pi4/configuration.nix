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
         (import "${home-manager}/nixos")
         (import "${impermanence}/nixos.nix")
       ];

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
       };

         # enable NAT
       nat = {
         enable = true;
         externalInterface = "eth0";
         internalInterfaces = [ "wg0" ];
         firewall = {
           allowedUDPPorts = [ 51820 ];
         };
       };

       # wireguard
       wireguard = {
         enable = true;
         interface."wireguard" = {
           privateKeyFile = "/var/wireguard-keys/private";
           ips = [ "04.07.21.1/24" ];
           listenPort = 51820;
           postSetup = ''
             ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 04.07.21.0/24 -o eth0 -j MASQUERADE
           '';
           postShutdown = ''
             ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 04.07.21.0/24 -o eth0 -j MASQUERADE
           '';
           peers = [
             {
                 # laptop
               publicKey = "ydKX8rqG/CUcjnTCZZfTBy14xzjEbLQy1q/NRkKDDSY=";
               allowedIPs = [ "04.07.21.2/24" ];
             }
           ];
         };
       };
     };
   };

     system.stateVersion = "22.05";
}
