{ config, pkgs, ... }: {

  networking = {
    hostName = "bin-server";
    firewall = {
      enable = true;
      allowedTCPPorts = [  ];
    };
    enableIPv6 = false;
    useDHCP = false;
    defaultGateway = "192.168.1.255";
    nameservers = [ "8.8.8.8" ];
    interfaces.enp7s0.ipv4.addresses = [{
      address = "192.168.1.141";
      prefixLength = 24;
   }];
  };

      # enable openssh daemon
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
    };

}
