{ config, pkgs, ... }: {

  networking = {
    hostName = "bin-server";
    firewall = {
      enable = true;
      allowedTCPPorts = [  ];
    };
    enableIPv6 = false;
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
  };

      # enable openssh daemon
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
    };

}
