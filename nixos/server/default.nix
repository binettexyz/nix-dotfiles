{ inputs, pkgs, config, lib, ... }:
with lib;

{
  imports = [
    ../minimal.nix
    ./containers ];


  options.nixos.server.enable = lib.mkEnableOption "laptop config" // {
    default = (config.modules.device.type == "server");
  };

  config = lib.mkIf config.nixos.server.enable {

    modules = {
      containers = {
        adGuardHome.enable = true;
#        home-assistant.enable = true;
        homer.enable = true;
        mcServer.enable = true;
#        nextcloud.enable = true;
        servarr.enable = true;
        vaultwarden.enable = true;
      };
    };
  
    services.nfs.server = {
      enable = true;
      exports = ''
        /media 100.91.89.2(rw,insecure,no_subtree_check)
        /media 100.67.150.87(rw,insecure,no_subtree_check)
      '';
    };

#    sops.secrets.wg-privateKey = {
#      format = "yaml";
        # can be also set per secret
#      sopsFile = ./secrets.yaml;
#    };

    networking = {
      nat = {
        enable = true;
        externalInterface = "eth0";
      };
#      wireguard.interfaces = {
#        wg0 = {
#          ips = [ "10.100.0.1/24" ];
#          listenPort = 51820;
#    
#            # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
#            # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
#          postSetup = ''
#            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
#          '';
#    
#          # This undoes the above command
#          postShutdown = ''
#            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
#          '';
#    
#          privateKeyFile = "/nix/persist/srv/private/wireguard/private";
#
#          peers = [
#            { # desktop 
#              publicKey = "aSJWCxae3dYewxZOlfwfOpc5K6uEHIeDGnmoSUzZFH8=";
#              allowedIPs = [ "10.100.0.2/32" "10.100.0.0/24" ];
#            }
#          ];
#        };
#      };
    };

#    services.caddy = {
#      enable = true;
#      globalConfig = ''
#        servers :443 {
#        }
#      '';
#    };

    services.nginx.enable = true;

#TODO    services.dnsmasq.enable = true;

        # Docker
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      enableNvidia = lib.mkDefault false;
      autoPrune.enable = true;
    };
  
    virtualisation.oci-containers.backend = "docker";
  
    ## FileSystem ##
    fileSystems."/nix/persist/media" = {
      device = "/dev/disk/by-label/exthdd";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" "gid=100" "x-systemd.automount" "noauto" ];
      
    };
  
    environment.persistence."/nix/persist" = {
      hideMounts = true;
      directories = [
        "/media"
      ];
    };

    environment.persistence."/nix/persist/home/binette/.local/share" = {
      hideMounts = true;
      directories = [
        { directory = "/opt"; user = "binette"; group = "binette"; mode = "u=rwx,g=rx,o="; }
      ];
    };
  };

}
