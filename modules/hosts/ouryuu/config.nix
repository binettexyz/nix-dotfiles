{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "ouryuu";
  flake.nixosModules.ouryuu = {
    imports = with inputs.self.nixosModules; [
      binette
      home-manager
      impermanence
      homelabPreset
    ];

    modules = {
      bootloader.default = "grub";
      device = {
        cpu = "intel";
        hostname = "ouryuu";
        network.ipv4 = {
          internal = "192.168.18.15";
          tailscale = "100.127.182.62";
        };
        storage.hdd = true;
        storage.ssd = true;
        type = "server";
      };
      homelab = {
        services = {
          #enable = true;
          docker.enable = true;
          nfs.enable = true;
          # ---Containers---
          cloudflare-ddns.enable = true;
          gitea.enable = true;
          homer.enable = true;
          home-assistant.enable = false;
          immich.enable = true;
          jellyfin.enable = true;
          miniflux.enable = true;
          nextcloud.enable = true;
          servarr.enable = true;
          vaultwarden.enable = true;
        };
      };
    };

    #    services.syncthing.settings.folders = {
    #      "gameSaves" = {
    #        path = "/data/gaming/saves";
    #        devices = [
    #          "suzaku"
    #          "seiryu"
    #        ];
    #      };
    #      "notes" = {
    #        path = "/data/library/notes";
    #        devices = [ "byakko" ];
    #      };
    #    };
  };
}
