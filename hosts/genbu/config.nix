{...}: {
  ## Custom modules ##
  modules = {
    bootloader.default = "rpi4";
    device = {
      network.ipv4 = {
        internal = "192.168.2.17";
        tailscale = "100.110.153.50";
      };
      type = "server";
    };
    server.containers = {
      actual-budget.enable = true;
      cloudflare-ddns.enable = true;
      gitea.enable = true;
      home-assistant.enable = true;
      homer.enable = true;
      miniflux.enable = true;
      nextcloud.enable = true;
      servarr.enable = true;
      vaultwarden.enable = true;
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
      devices = ["suzaku" "byakko"];
    };
  };
}
