{
  config,
  lib,
  ...
}:
let
  service = "cloudflare-ddns";
  cfg = config.modules.homelab.services.${service};
  hl = config.modules.homelab;
in
{
  options.modules.homelab.services.${service} = {
    enable = lib.mkEnableOption "Create systemd service for cloudflare ddns updater";
    onCalendar = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
    };
    address = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.1";
      };
      local = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.11";
      };
    };
  };

  config = lib.mkIf (hl.enable && cfg.enable) {
    sops.secrets."server/containers/cloudflare-token" = {
      mode = "0400";
      format = "yaml";
    };
    sops.secrets."server/containers/cloudflare-zoneID" = {
      mode = "0400";
      format = "yaml";
    };
    sops.secrets."server/containers/cloudflare-public_recordID" = {
      mode = "0400";
      format = "yaml";
    };
    sops.secrets."server/containers/cloudflare-private_recordID" = {
      mode = "0400";
      format = "yaml";
    };

    containers.${service} = {
      autoStart = true;
      privateNetwork = true;
      localAddress = cfg.address.local;
      hostAddress = cfg.address.host;

      bindMounts = {
        "/run/secrets/server/containers/cloudflare-token" = {
          hostPath = config.sops.secrets."server/containers/cloudflare-token".path;
          isReadOnly = true;
        };
        "/run/secrets/server/containers/cloudflare-zoneID" = {
          hostPath = config.sops.secrets."server/containers/cloudflare-zoneID".path;
          isReadOnly = true;
        };
        "/run/secrets/server/containers/cloudflare-public_recordID" = {
          hostPath = config.sops.secrets."server/containers/cloudflare-public_recordID".path;
          isReadOnly = true;
        };
        "/run/secrets/server/containers/cloudflare-private_recordID" = {
          hostPath = config.sops.secrets."server/containers/cloudflare-private_recordID".path;
          isReadOnly = true;
        };
      };

      config =
        { pkgs, ... }:
        {
          system.stateVersion = "25.05";

          systemd.services.${service} = {
            description = "Cloudflare DDNS";
            wantedBy = [ "multi-user.target" ];
            wants = [ "network-online.target" ];
            after = [ "network-online.target" ];
            path = [ pkgs.curl ];
            script = ''
              #!/usr/bin/env bash
              CLOUDFLARE_API_TOKEN="$(cat "/run/secrets/server/containers/cloudflare-token")";
              CLOUDFLARE_ZONE_ID="$(cat "/run/secrets/server/containers/cloudflare-zoneID")";
              CLOUDFLARE_A_PUBLIC_RECORD_IDS="$(cat "/run/secrets/server/containers/cloudflare-public_recordID")";
              CLOUDFLARE_A_PRIVATE_RECORD_IDS="$(cat "/run/secrets/server/containers/cloudflare-private_recordID")";
              #set -euo pipefail
              echo "updating"
              if [ -n "''${CLOUDFLARE_A_PUBLIC_RECORD_IDS:-}" ]; then
              	addr=$(curl -sS 'https://1.1.1.1/cdn-cgi/trace' | grep 'ip=' | cut -d '=' -f 2)
              	for rid in $CLOUDFLARE_A_PUBLIC_RECORD_IDS; do
              		echo "''${rid} A ''${addr}"
              		curl -sS \
              			-X PATCH "https://api.cloudflare.com/client/v4/zones/''${CLOUDFLARE_ZONE_ID}/dns_records/''${rid}" \
              			-H "Authorization: Bearer ''${CLOUDFLARE_API_TOKEN}" \
              			-H 'Content-Type: application/json' \
              			--data "{\"content\": \"''${addr}\"}"
              	done
              fi
              if [ -n "''${CLOUDFLARE_A_PRIVATE_RECORD_IDS:-}" ]; then
              	addr=${config.modules.device.network.ipv4.tailscale}
              	for rid in $CLOUDFLARE_A_PRIVATE_RECORD_IDS; do
              		echo "''${rid} A ''${addr}"
              		curl -sS \
              			-X PATCH "https://api.cloudflare.com/client/v4/zones/''${CLOUDFLARE_ZONE_ID}/dns_records/''${rid}" \
              			-H "Authorization: Bearer ''${CLOUDFLARE_API_TOKEN}" \
              			-H 'Content-Type: application/json' \
              			--data "{\"content\": \"''${addr}\"}"
              	done
              fi
              echo "done"
            '';
          };

          systemd.timers.${service} = {
            description = "Cloudflare DDNS";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = cfg.onCalendar;
              Unit = "${service}.service";
            };
          };
        };
    };
  };
}
