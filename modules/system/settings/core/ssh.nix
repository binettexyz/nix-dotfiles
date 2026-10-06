{
  flake.nixosModules.ssh = {
    # Enable OpenSSH
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      allowSFTP = true;
      ports = [ 704 ];
      authorizedKeysInHomedir = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
      };
      extraConfig = ''
        UsePam no
        AllowTcpForwarding yes
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };

    # Add SSH key
    users.users.binette.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWNbKHKSSjQAEGlWVhrPQ8vcolszTiwNKXB0FMEBtfw binette@wakizashi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGCeXiJDdM7HHV4lB9pr/hghNYfUSrAe9MSbYygcSgK binette@tsuki"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSCs0LTpqOFmalhEbJKGyM5GtomJD6+yKozmvzlFphV binette@ouryuu"
    ];
  };

  flake.modules.homeManager.ssh =
    {
      config,
      ...
    }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
          "kura" = {
            hostname = "100.127.182.62";
            user = "${config.meta.username}";
            port = 704;
          };
          "wakizashi" = {
            hostname = "100.104.41.3";
            user = "${config.meta.username}";
            port = 704;
          };
          "tsuki" = {
            hostname = "100.114.180.61";
            user = "${config.meta.username}";
            port = 704;
          };
          "kei" = {
            hostname = "100.100.100.10";
            user = "${config.meta.username}";
            port = 704;
          };
        };
      };
    };
}
