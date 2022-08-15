{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-radarr" ];
  networking.firewall.allowedTCPPorts = [ 7878 ];

  containers.radarr = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = true;
#    hostBridge = "br0";
    hostAddress = "192.168.100.11";
    localAddress = "192.168.100.11";

      # mounts
    bindMounts = {
      "/var/lib/radarr" = {
        hostPath = "/var/lib/radarr";
        isReadOnly = false;
      };
    };

    forwardPorts = [
			{
				containerPort = 7878;
				hostPort = 7878;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.05";
      networking.hostName = "radarr";

      services.radarr = {
        enable = true;
        user = "radarr";
        group = "radarr";
        openFirewall = true;
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/radarr/.config/radarr 700 radarr radarr -"
      ];
    };
  };

}
