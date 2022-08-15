{config, lib, pkgs, ... }: {

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-sonarr" ];
    externalInterface = "wlo1";
  };
  networking.firewall.allowedTCPPorts = [ 8989 ];

  containers.sonarr = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = true;
#    hostBridge = "br0";
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

      # mounts
    bindMounts = {
      "/var/lib/sonarr" = {
        hostPath = "/nix/persist/var/lib/sonarr";
        isReadOnly = false;
      };        
    };

    config = { config, pkgs, ... }: {

    system.stateVersion = "22.05";

      services.sonarr = {
        enable = true;
        openFirewall = true;
      };

      networking.hostName = "sonarr";

      systemd.tmpfiles.rules = [
        "d /var/lib/sonarr/.config/NzbDrone 700 sonarr sonarr -"
      ];
    };

    forwardPorts = [
			{
				containerPort = 8989;
				hostPort = 8989;
				protocol = "tcp";
			}
		];

  };

}
