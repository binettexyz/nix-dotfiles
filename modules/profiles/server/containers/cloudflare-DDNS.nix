{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.containers.cloudflare-ddns;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.11";
in {
  options.modules.server.containers.cloudflare-ddns = {
    enable = lib.mkOption {
      description = "Create systemd service for cloudflare ddns updater";
      default = false;
    };
    onCalendar = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
    };
  };

  config = lib.mkIf cfg.enable {
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

    containers.cloudflare-ddns = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      inherit localAddress hostAddress;

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

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";

        systemd.services.cloudflare-ddns = {
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
            	addr=${config.device.network.ipv4.tailscale}
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
    
        systemd.timers.cloudflare-ddns = {
          description = "Cloudflare DDNS";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = config.modules.server.containers.cloudflare-ddns.onCalendar;
            Unit = "cloudflare-ddns.service";
          };
        };
      };
    };
  };
}
