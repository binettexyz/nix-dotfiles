{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.minecraft-server;
in
{
  options.modules.containers.minecraft-server = {
    enable = mkOption {
      description = "Enable minecraft server";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-minecraft" ];
    networking.firewall.allowedTCPPorts = [ 25565 ];
  
    containers.minecraft-server = {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
      bindMounts = {
        "/var/lib/minecraft" = {
          hostPath = "/nix/persist/home/binette/.local/share/minecraft";
          isReadOnly = false;
        };
  
      };
  
      forwardPorts = [
  			{
  				containerPort = 25565;
  				hostPort = 25565;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }: {

        system.stateVersion = "22.11";
        networking.hostName = "minecraft-server";
        nixpkgs.config.allowUnfree = true;

        services.minecraft-server = {
          enable = true;
          declarative = true;
          eula = true;
          dataDir = "/var/lib/minecraft";
          openFirewall = true;
          package = pkgs.minecraft-server;
      
          jvmOpts = "-Xmx1024M -Xms1024M";
      
          serverProperties = {
            motd = "Nixos Minecraft Server";
            level-name = "Binette's Survival";
            server-port = 25565;
            difficulaty = 2;
            hardcore = true;
            gamemode = 0;
            max-player = 2;
            white-list = false;
            enable-rcon = false;
            allow-flight = false;
            online-mode = true;
            view-distance = 16;
            simulation-distance = 10;
          };
        };

#       sops.secrets."restic/password".sopsFile = ../secrets/restic.yaml;
#       sops.secrets."restic/environment".sopsFile = ../secrets/restic.yaml;

#       services.restic.backups.minecraft = {
#         initialize = true;
#         passwordFile = config.sops.secrets."restic/password".path;
#         environmentFile = config.sops.secrets."restic/environment".path;
#         repository = "b2:imsofi-infra:minecraft";
#         paths = [ "/var/lib/minecraft" ];
#         pruneOpts = [ "--keep-daily 31" ];
#         timerConfig = {
#           OnCalendar = "06:30";
#           RandomizedDelaySec = "30m";
#         };
#         backupPrepareCommand = ''
#           echo "say Starting backup..." > /run/minecraft-server.stdin
#           echo save-off > /run/minecraft-server.stdin
#           echo save-all > /run/minecraft-server.stdin
#           sleep 5
#         '';
#         backupCleanupCommand = ''
#           echo save-on > /run/minecraft-server.stdin
#           echo "say Backup complete!" > /run/minecraft-server.stdin
#         '';
#       };

#       systemd.services.restic-backups-minecraft = {
#         partOf = [ "minecraft-server.service" ];
#         requisite = [ "minecraft-server.service" ];
#         after = [ "minecraft-server.service" ];
      };
    };
  };

}

