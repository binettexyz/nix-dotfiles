{lib, ...}: {
  ## Custom modules ##
  modules = {
    bootloader.default = "rpi4";
    server.containers = {
      actual-budget.enable = true;
      cloudflare-ddns.enable = true;
      gitea.enable = true;
      home-assistant.enable = true;
      miniflux.enable = true;
      nextcloud.enable = true;
      vaultwarden.enable = true;
    };
    system = {
      home.enable = true;
    };
  };

  device.network.ipv4 = {
    internal = "192.168.2.17";
    tailscale = "100.110.153.50";
  };

  services.syncthing.settings.folders = {
    "gameSaves" = {
      path = "/data/gaming/saves";
      devices = ["seiryu" "gyorai"];
    };
    "notes" = {
      path = "/data/library/notes";
      devices = ["seiryu" "hayate"];
    };
  };
}
