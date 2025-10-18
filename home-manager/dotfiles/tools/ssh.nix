{
  pkgs,
  config,
  lib,
  ...
}: {
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
      "suzaku" = {
        user = "${config.home.username}";
        hostname = "100.72.86.100";
        port = 704;
      };
      "genbu" = {
        hostname = "100.110.153.50";
        port = 704;
      };
      "seiryu" = {
        hostname = "100.102.251.119";
        user = "${config.home.username}";
        port = 704;
      };
      "byakko" = {
        hostname = "100.102.251.119";
        user = "${config.home.username}";
        port = 704;
      };
      "kei" = {
        hostname = "100.95.71.37";
        user = "${config.home.username}";
        port = 704;
      };
    };
  };
}
