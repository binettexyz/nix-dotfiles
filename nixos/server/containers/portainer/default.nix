{ config, pkgs, ... }:
{

  virtualisation.oci-containers.containers = {
    portainer = {
      image = "portainer/portainer-ce:latest";
      autoStart = true;
      ports = [
        "8000:8000"
        "9443:9443"
      ];
      volumes = [
        "/Configs/portainer:/data"
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
    };
  };
}
