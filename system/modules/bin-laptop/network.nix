{ config, pkgs, ... }: {

  networking = {
    hostName = "bin-laptop";
    firewall.enable = true;
    enableIPv6 = false;
    useDHCP = false;
    wireless.enable = false;
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
  };

      # enable openssh daemon
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
    };

  programs = {
#    mtr.enable = true;
#    gnupg.agent = {
#      enable = true;
#      enableSSHSupport = true;
#    };
    tmux = {
      enable = true;
    };
  };

}
