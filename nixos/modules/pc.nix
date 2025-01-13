{ pkgs, config, flake, lib, ... }:
let
  inherit (config.meta) username;
in
  with config.users.users.${username};
{

  config = lib.mkIf (config.device.type == "laptop") {
      # enable suckless window manager
    services.xserver.windowManager.dwm.enable = true;
  
    #TODO: users.users.${username} = { extraGroups = [ ]; };
  
    services = {
        # Enable irqbalance service
      irqbalance.enable = true;
        # Enable printing
      printing = { enable = true; drivers = with pkgs; [ ]; };
      dbus.implementation = "broker";
  #    udisks2.enable = true;
        # Enable clipboard manager
      greenclip.enable = true;
      gvfs.enable = true;
      unclutter-xfixes = {
        enable = true;
        extraOptions = [
          "start-hiden"
        ];
      };
      xbanish.enable = true;
    };
      # Enable opengl
    hardware.graphics = {
      enable = true; 
      enable32Bit = true;
    };
  
    services.journald.extraConfig = ''
      systemMaxUse=100M
      MaxFileSec=7day
    '';
  
      # TODO:
    #systemd.tmpfiles.rules = [
      #"d ${archive}/Downloads 0775 ${username} ${group}"
      #"d ${archive}/Music 0775 ${username} ${group}"
      #"d ${archive}/Photos 0775 ${username} ${group}"
      #"d ${archive}/Videos 0775 ${username} ${group}"
    #];
  
  
  #  /* --- Transmission Container --- */
  #  containers.transmission =
  #    let
  #      downloadDir = "/var/lib/nixos-containers/transmission/var/lib/transmission/Downloads";
  #      downloadIncompleteDir = "/var/lib/nixos-containers/transmission/var/lib/transmission/.incomplete";
  #      ports.transmission = 9091;
  #    in {
  #      autoStart = true;
  #      ephemeral = true;
  #    
  #        # networking & port forwarding
  #      privateNetwork = true;
  #      hostAddress = "10.0.0.17";
  #      localAddress = "10.0.0.18";
  #    
  #        # mounts
  #      bindMounts = {
  #        "/home/downloads/torrents" = { hostPath = downloadDir; isReadOnly = false; };
  #        "/home/downloads/torrents/.incomplete" = { hostPath = downloadIncompleteDir; isReadOnly = false; };
  #      };
  #    
  #      #TODO: make local dns rule
  #      forwardPorts = [
  #  			{
  #  				containerPort = ports.transmission;
  #  				hostPort = ports.transmission;
  #  				protocol = "tcp";
  #  			}
  #  		];
  #  
  #      config = { config, pkgs, ... }: {
  #  
  #        networking.firewall.allowedTCPPorts = [ 9091 ];
  #  
  #        services.transmission = {
  #          enable = true;
  #          home = "/var/lib/transmission";
  #          user = "transmission";
  #          group = "users";
  #          openFirewall = true;
  #          settings = {
  #            blocklist-enabled = true;
  #            blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
  #            incomplete-dir-enabled = true;
  #            watch-dir-enabled = false;
  #            encryption = 1;
  #            message-level = 1;
  #            peer-port = 50778;
  #            peer-port-random-high = 65535;
  #            peer-port-random-low = 49152;
  #            peer-port-random-on-start = true;
  #            rpc-enable = true;
  #            rpc-bind-address = "0.0.0.0";
  #            rpc-port = ports.transmission;
  #            rpc-authentication-required = true;
  #            rpc-username = "binette";
  #            rpc-password = "cd";
  #            rpc-whitelist-enabled = false;
  #            umask = 18;
  #            utp-enabled = true;
  #          };
  #        };
  #  
  #        system.stateVersion = "22.11";
  #      };
  #  };
  };

}

