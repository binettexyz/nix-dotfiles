{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-deluge" ];
  networking.firewall.allowedTCPPorts = [ 8112 ];

  containers.deluge = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = false;
#    hostBridge = "br0";
    hostAddress = "192.168.100.13";
    localAddress = "192.168.100.23";

      # mounts
    bindMounts = {
      "/var/lib/deluge" = {
        hostPath = "/nix/persist/var/lib/deluge";
        isReadOnly = false;
      };        
    };

    forwardPorts = [
			{
				containerPort = 8112;
				hostPort = 8112;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.05";
      networking.hostName = "deluge";

      services.deluge = {
        enable = true;

        web = {
          enable = true;
          port = 8112;
          openFirewall = true;
        };

        declarative = true;
        dataDir = "/var/lib/deluge";
        openFirewall = true;
        authFile = "/var/lib/deluge/auth";
      };


      ];
    };
  };

}
