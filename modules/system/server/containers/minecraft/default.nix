{ config, pkgs, lib, inputs, ... }: {
  
#  sops.secrets."restic/password".sopsFile = ../secrets/restic.yaml;
#  sops.secrets."restic/environment".sopsFile = ../secrets/restic.yaml;

#  services.restic.backups.minecraft = {
#    initialize = true;
#    passwordFile = config.sops.secrets."restic/password".path;
#    environmentFile = config.sops.secrets."restic/environment".path;
#    repository = "b2:imsofi-infra:minecraft";
#    paths = [ "/var/lib/minecraft" ];
#    pruneOpts = [ "--keep-daily 31" ];
#    timerConfig = {
#      OnCalendar = "06:30";
#      RandomizedDelaySec = "30m";
#    };
#    backupPrepareCommand = ''
#      echo "say Starting backup..." > /run/minecraft-server.stdin
#      echo save-off > /run/minecraft-server.stdin
#      echo save-all > /run/minecraft-server.stdin
#      sleep 5
#    '';
#    backupCleanupCommand = ''
#      echo save-on > /run/minecraft-server.stdin
#      echo "say Backup complete!" > /run/minecraft-server.stdin
#    '';
#  };

#  systemd.services.restic-backups-minecraft = {
#    partOf = [ "minecraft-server.service" ];
#    requisite = [ "minecraft-server.service" ];
#    after = [ "minecraft-server.service" ];
#  };

  services.minecraft-server = {
    enable = true;
    declarative = true;
    eula = true;
    dataDir = "/var/lib/minecraft/vanilla";
    openFirewall = true;
    package = pkgs.minecraft-server;

    jvmOpts = "-Xmx4096M -Xms4096M";

    serverProperties = {
      motd = "Nixos Minecraft Server";
      level-name = "Binette's servival";
      server-port = 25565;
      difficulaty = 2;
      hardcore = true;
      gamemode = 0;
      max-player = 2;
      white-list = false;
      enable-rcon = true;
      allow-flight = false;
      online-mode = true;
      server-ip = "";
      view-distance = 16;
      simulation-distance = 10;
    };
  };
}
