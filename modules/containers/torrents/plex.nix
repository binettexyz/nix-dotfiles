{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-plex" ];
  networking.firewall.allowedTCPPorts = [ 32400 ];

  containers.plex = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = true;
    hostAddress = "192.168.300.10";
    localAddress = "192.168.300.11";

      # mounts
    bindMounts = {
      "/var/lib/plex" = {
        hostPath = "/nix/persist/var/lib/plex";
        isReadOnly = false;
      };        
    };

    forwardPorts = [
			{
				containerPort = 32400;
				hostPort = 32400;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.05";
      networking.hostName = "plex";

      services.plex = {
        enable = true;
        user = "plex";
        group = "plex";
        openFirewall = true;
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/plex 700 plex plex -"
      ];
    };
  };

}
