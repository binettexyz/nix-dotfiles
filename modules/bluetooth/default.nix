{ config, pkgs, lib, ... }: {

        hardware = {
                bluetooth.enable = false;
        };

#        services.blueman.enable = lib.mkIf (config.services.xserver.enable) true;
#        programs.dconf.enable = lib.mkIf (config.services.xserver.enable) true;

}
