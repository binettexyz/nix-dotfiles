{ config, pkgs, ... }: {

  networking = {
    hostName = "bin-laptop";
    firewall.enable = true;
    enableIPv6 = false;
    useDHCP = false;

      # networkManager
#   wireless.enable = false;
#   networkmanager = {
#     enable = true;
#     wifi.powersave = true;
#    };

      # wpa_supplicant
    interfaces.wlp3s0.useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlp3s0" ];
      userControlled.enable = true;
      networks = {
          # home
        "DD-WRT" = {
          priority = 0;
          pskRaw = "ecae0b81eb975c57daa6222e7cf2278fd055f6172a7bfe64cf8340c620814364";
        };
          # work
        "FONDATIONHBM" = {
          priority = 1;
          pskRaw = "6df6c695105bc76306832ba0643f9de718f72d8886e072605f5ef256f8df5542";
        };

#          # girlfriend's
#        "VIDEOTRON5124" = {
#          priority = 2;
#          pskRaw = "...";
#        };
      };
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
