{
  lib,
  flake,
  ...
}: {
  ## Custom modules ##
  modules = {
    bootloader.default = "rpi4";
    server.containers = {
      cloudflare-ddns.enable = true;
      gitea.enable = true;
      home-assistant.enable = false;
      miniflux.enable = true;
      vaultwarden.enable = true;
    };
    system = {
      home.enable = true;
    };
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
