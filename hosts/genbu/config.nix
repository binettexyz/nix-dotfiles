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
    homelab = {
      enable = true;
      services = {
        enable = true;
        cloudflare-ddns.enable = true;
        gitea.enable = true;
        homer.enable = true;
        miniflux.enable = true;
        nextcloud.enable = true;
        vaultwarden.enable = true;
      };
    };
    server.containers = {
      actual-budget.enable = true;
      home-assistant.enable = false;
      servarr.enable = true;
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
