{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.mcServer;
in
{
  options.modules.containers.mcServer = {
    enable = mkOption {
      description = "Enable minecraft server";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-mcServer" ];
    networking.firewall.allowedTCPPorts = [ 25565 25575 ];
  
    containers.mcserver = {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
      bindMounts = {
        "/opt/minecraft/server" = {
          hostPath = "/opt/minecraft/server";
          isReadOnly = false;
        };
  
      };
  
      forwardPorts = [
  			{
  				containerPort = 25565;
  				hostPort = 25565;
  				protocol = "tcp";
  			}
        {
  				containerPort = 25575;
  				hostPort = 25575;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }:
      let
        MIN_MEM = "512M";
        MAX_MEM = "1024M";
        PORT = "25575";
        IP = "localhost";
        #IP = "100.71.254.90";
        PASSWD = "cd";
        DELAY = "5";
        JARFILE = "server.jar";

      in { 

        system.stateVersion = "22.11";
        networking.hostName = "mcserver";

        environment.systemPackages = with pkgs; [ killall jdk curl wget jq lf ];


        users = {
          allowNoPasswordLogin = true;
          mutableUsers = false;
          groups.minecraft.gid = 1000;
          users.steve = {
            uid = 1000;
            isNormalUser = true;
            createHome = true;
            home = "/opt/minecraft";
            group = "minecraft";
            extraGroups = [ "minecraft" ];
          };
        };

        systemd.services."mcServer@" = {
          wantedBy = [ "multi-user.target" ];
          after    = [ "network.target" ];
      
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
            ExecReload = ''${pkgs.mcrcon}/bin/mcrcon -H ${IP} -P ${PORT} -p ${PASSWD} -w ${DELAY} "say Server reload in 5 seconds..." reload'';
            ExecStop = ''${pkgs.mcrcon}/bin/mcrcon -H ${IP} -P ${PORT} -p ${PASSWD} -w ${DELAY} "say Server is shutting down.." save-all stop'';
      
            Restart = "on-failure";
            RestartSec = "60s";
          };
          preStart =
          let
            eulaFile = builtins.toFile "eula.txt" ''
              # eula.txt managed by NixOS Configuration
              eula=true
            '';
            API = "https://papermc.io/api/v2/projects/paper";
            VER = "1.19.2";
            BUILDS_JSON = "$(${pkgs.curl}/bin/curl -s ${API}/versions/${VER})";
            LATEST = ''$(echo "${BUILDS_JSON}" | ${pkgs.jq}/bin/jq '.builds[-1]')'';
            PFILE = "paper-${VER}-${LATEST}.jar";
          in
            ''
              ln -sf ${eulaFile} eula.txt
            
              if [ -e "${PFILE}" ]; then
                echo "latest file exists: "${PFILE}""
              else
                ${pkgs.wget}/bin/wget "${API}/versions/${VER}/builds/${LATEST}/downloads/${PFILE}"
                if [ -e "${PFILE}" ]; then
                  echo "update paper server: ${PFILE}"
                  rm -vf server.jar
                  ln -sv "${PFILE}" server.jar
                else
                  echo "fail to download jar file"
                fi
              fi       
            '';
        };
      };
    };
  };

}
