{ pkgs, ... }: {

  systemd.services."mcServer@" = {
    wantedBy = [ "multi-user.target" ];
    after    = [ "network.target" ];

    unitConfig = {
      Description = "Minecraft Server %i";
    };

    serviceConfig = {
      WorkingDirectory = "/opt/minecraft/server/%i";
        # Set default memory values
      Environment = ''"MEM=1024" "SHUTDOWN_DELAY=5" "POST_SHUTDOWN_DELAY=10" "JARFILE=server.jar"'';
        # Change memory values in environment file
      EnvironmentFile = "-/opt/minecraft/server/%i/server.conf";
      
        # Users Database is not available for within the unit, only root and steve is available, everybody else is nobody
      PrivateUsers = true;
      
      User = "steve";
      Group = "minecraft";
      
        # Read only mapping of /usr /boot and /etc
      ProtectSystem = "full";
      
        # /home, /root and /run/user seem to be empty from within the unit. It is recommended to enable this setting for all long-running services (in particular network-facing ones).
      ProtectHome = true;
      
        # /proc/sys, /sys, /proc/sysrq-trigger, /proc/latency_stats, /proc/acpi, /proc/timer_stats, /proc/fs and /proc/irq will be read-only within the unit. It is recommended to turn this on for most services.
        # Implies MountFlags=slave
      ProtectKernelTunables = true;
      
        # Block module system calls, also /usr/lib/modules. It is recommended to turn this on for most services that do not need special file systems or extra kernel modules to work
        # Implies NoNewPrivileges=yes
      ProtectKernelModules = true;
      
        # It is hence recommended to turn this on for most services.
        # Implies MountAPIVFS=yes
      ProtectControlGroups = true;
      
        # screen will be kill without killmode
      KillMode = "none";
      #KillSignal = "SIGCONT";
      
        # Uncomment this to fix screen on RHEL 8
      ExecStartPre = "+/bin/sh -c 'chmod 777 /run/screens'";
      
      ExecStart = "/usr/bin/screen -DmS mc-%i /usr/bin/java -Xmx${MEM} -Xms${MEM} -jar ${JARFILE} nogui";
      
      ExecReload = '' /usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "reload"\\015' '';
      
      ExecStop = [
        '' /usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "say SERVER SHUTTING DOWN. Saving map..."\\015' ''
        '' /bin/sh -c '/bin/sleep ${SHUTDOWN_DELAY}' ''
        '' /usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "save-all"\\015' ''
        '' /usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "stop"\\015' ''
        '' /bin/sh -c '/bin/sleep ${POST_SHUTDOWN_DELAY}' ''
      ];
      
      Restart = "on-failure";
      RestartSec = "60s";
    };
  };

}
