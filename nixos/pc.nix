{ pkgs, config, flake, lib, ... }:
let
  inherit (config.meta) username;
in
  with config.users.users.${username};
{

  imports = [
    #./libvirt
  ];

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
  hardware.opengl = {
    enable = true; 
    driSupport32Bit = true;
    driSupport = true;
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


  /* --- Transmission Container --- */
  networking.nat.internalInterfaces = [ "ve-transmission" ];
  networking.firewall.allowedTCPPorts = [ 9091 ];

  containers.transmission = {
    autoStart = true;
    ephemeral = true;
  
      # networking & port forwarding
    privateNetwork = true;
    hostAddress = "10.0.0.17";
    localAddress = "10.0.0.18";
  
      # mounts
    bindMounts = {
      "/var/lib/transmission" = {
        hostPath = "/var/lib/transmission";
        isReadOnly = false;
      };
    };
  
    forwardPorts = [
			{
				containerPort = 9091;
				hostPort = 9091;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.11";
      networking.hostName = "transmission";

      services.transmission = {
        enable = true;
        home = "/var/lib/transmission";
        user = "transmission";
        group = "users";
        openFirewall = true;
        settings = {
          blocklist-enabled = true;
          blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
          incomplete-dir-enabled = true;
          watch-dir-enabled = false;
          encryption = 1;
          message-level = 1;
          peer-port = 50778;
          peer-port-random-high = 65535;
          peer-port-random-low = 49152;
          peer-port-random-on-start = true;
          rpc-enable = true;
          rpc-bind-address = "0.0.0.0";
          rpc-port = 9091;
          rpc-authentication-required = true;
          rpc-username = "binette";
          rpc-password = "cd";
          rpc-whitelist-enabled = false;
          umask = 18;
          utp-enabled = true;
        };
      };
    };
  };

}

