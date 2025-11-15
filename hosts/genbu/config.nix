{...}: {
  # ---Custom modules---
  modules = {
    bootloader.default = "rpi4";
    device = {
      network.ipv4 = {
        internal = "192.168.2.17";
        tailscale = "100.110.153.50";
      };
      type = "server";
    };
    homelab = {
      enable = true;
      services = {
        enable = true;
        docker.enable = true;
        nfs.enable = true;
        # ---Containers---
        cloudflare-ddns.enable = true;
        gitea.enable = true;
        homer.enable = true;
        home-assistant.enable = false;
        immich.enable = true;
        miniflux.enable = true;
        nextcloud.enable = true;
        sonarr.enable = true;
        vaultwarden.enable = true;
      };
    };
    system = {
      home.enable = true;
    };
  };

  services.syncthing.settings.folders = {
    "gameSaves" = {
      path = "/data/gaming/saves";
      devices = ["suzaku" "seiryu"];
    };
    "notes" = {
      path = "/data/library/notes";
      devices = ["byakko"];
    };
  };
}
