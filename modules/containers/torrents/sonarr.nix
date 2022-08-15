{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-sonarr" ];

  containers.sonarr = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = true;

      # mounts
    bindMounts = {
      "/var/lib/sonarr" = {
        hostPath = "/nix/persist/var/lib/sonarr";
        isReadOnly = false;
      };        
    };

    config = { config, pkgs, ... }: {

      services.sonarr = {
        enable = true;
        openFirewall = true;
      };

      networking.hostName = "sonarr";

      systemd.tmpfiles.rules = [
        "d /var/lib/sonarr/.config/NzbDrone 700 sonarr sonarr -"
      ];
    };
  };

}
