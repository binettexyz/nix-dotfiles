{
  pkgs,
  config,
  lib,
  ...
}: let
  serverDataDir = "/opt/minecraft/server";
  ports = {
    server = 25565;
    rcon = 25575;
  };
  MIN_MEM = "512M";
  MAX_MEM = "3072M";
  IP = "localhost";
  #IP = "100.71.254.90";
  PASSWD = "cd";
  DELAY = "5";
  JARFILE = "server.jar";
in {
  options.gaming.mcServer.enable = pkgs.lib.mkDefaultOption "minecraft server";

  config = lib.mkIf config.gaming.mcServer.enable {
    networking.firewall = {
      allowedTCPPorts = [
        ports.server
        ports.rcon
      ];
    };
    users = {
      allowNoPasswordLogin = true;
      mutableUsers = false;
      #      groups.minecraft.gid = 2000;
      groups.minecraft.members = ["steve"];
      users.steve = {
        #        uid = 2000;
        isNormalUser = true;
        createHome = true;
        home = "/opt/minecraft";
        group = "minecraft";
        extraGroups = ["minecraft"];
      };
    };
    systemd.services."mcServer@" = {
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];

      unitConfig = {
        Description = "Minecraft Server %i";
      };

      serviceConfig = {
        WorkingDirectory = "/opt/minecraft/server/%i";
        ReadWriteDirectories = "/opt/minecraft/server";

        PrivateUsers = true;
        User = "steve";
        Group = "minecraft";
        Nice = 5; # Lower priority than most other things that run on the server

        ProtectHome = true;
        ProtectSystem = "strict"; # Makes /usr /boot /etc /dev /proc /sys read-only
        ProtectControlGroups = true;
        #InaccessibleDirectories = "/root /srv /mounts /var -/lost+found";
        PrivateDevices = true;
        NoNewPrivileges = true;
        PrivateTmp = true;

        # /proc/sys, /sys, /proc/sysrq-trigger, /proc/latency_stats, /proc/acpi, /proc/timer_stats, /proc/fs and /proc/irq will be read-only within the unit. It is recommended to turn this on for most services.
        # Implies MountFlags=slave
        ProtectKernelTunables = true;

        # Block module system calls, also /usr/lib/modules. It is recommended to turn this on for most services that do not need special file systems or extra kernel modules to work
        # Implies NoNewPrivileges=yes
        ProtectKernelModules = true;

        # The server is not killed when the service is stoped
        KillMode = "none";
        # Mark services a successfully exited
        SuccessExitStatus = "0 1";

        ExecStart = "${pkgs.jdk}/bin/java -Xms${MIN_MEM} -Xmx${MAX_MEM} -jar ${JARFILE} nogui";
        ExecReload = ''${pkgs.mcrcon}/bin/mcrcon -H ${IP} -P ${lib.toString ports.rcon} -p ${PASSWD} -w ${DELAY} "say Server reload in 5 seconds..." reload'';
        ExecStop = ''${pkgs.mcrcon}/bin/mcrcon -H ${IP} -P ${lib.toString ports.rcon} -p ${PASSWD} -w ${DELAY} "say Server is shutting down.." save-all stop'';

        Restart = "on-failure";
        RestartSec = "60s";
      };
      preStart = let
        eulaFile = builtins.toFile "eula.txt" ''
          # eula.txt managed by NixOS Configuration
          eula=true
        '';
        propertiesFile = builtins.toFile "server.properties" ''
          difficulty=normal
          hardcore=false
          enable-jmx-monitoring=false
          rcon.port=25575
          level-seed=
          gamemode=survival
          enable-command-block=false
          enable-query=false
          generator-settings={}
          enforce-secure-profile=true
          level-name=world
          motd=NixOS Minecraft Server
          query.port=25565
          pvp=true
          generate-structures=true
          max-chained-neighbor-updates=1000000
          network-compression-threshold=256
          max-tick-time=60000
          require-resource-pack=false
          use-native-transport=true
          max-players=5
          online-mode=true
          enable-status=true
          allow-flight=true
          broadcast-rcon-to-ops=true
          view-distance=16
          server-ip=
          resource-pack-prompt=
          allow-nether=true
          server-port=25565
          enable-rcon=true
          sync-chunk-writes=true
          op-permission-level=4
          prevent-proxy-connections=false
          hide-online-players=false
          resource-pack=
          entity-broadcast-range-percentage=100
          simulation-distance=10
          rcon.password=cd
          player-idle-timeout=0
          debug=false
          force-gamemode=false
          rate-limit=0
          white-list=false
          broadcast-console-to-ops=true
          spawn-npcs=true
          previews-chat=false
          spawn-animals=true
          function-permission-level=2
          level-type=minecraft\:normal
          text-filtering-config=
          spawn-monsters=true
          enforce-whitelist=false
          spawn-protection=16
          resource-pack-sha1=
          max-world-size=29999984
        '';
      in ''
        ln -sf ${eulaFile} eula.txt

        if [ -e "server.properties" ]; then
          exit 1
        else
          cp ${propertiesFile} server.properties
        fi
      '';
    };
  };
}
