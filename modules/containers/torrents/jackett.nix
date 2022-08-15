{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-jackett" ];
  networking.firewall.allowedTCPPorts = [ 9117 ];

  containers.sonarr = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = true;
    hostAddress = "192.168.400.10";
    localAddress = "192.168.400.11";

      # mounts
    bindMounts = {
      "/var/lib/jackett/.config/Jackett" = {
        hostPath = "/nix/persist/var/lib/jackett/.config/Jackett";
        isReadOnly = false;
      };        
    };

    forwardPorts = [
			{
				containerPort = 9117;
				hostPort = 9117;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.05";
      networking.hostName = "jackett";

      services.sonarr = {
        enable = true;
        user = "jackett";
        group = "jackett";
        openFirewall = true;
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/jackett/.config/Jackett 700 jackett jackett -"
      ];
    };
  };

}
