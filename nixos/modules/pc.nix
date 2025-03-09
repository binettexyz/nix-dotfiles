{ pkgs, config, flake, lib, ... }:
let
  inherit (config.meta) username;
in
  with config.users.users.${username};
{

  config = lib.mkIf (config.device.type == "workstation") {
      # enable suckless window manager
    services.xserver.windowManager.dwm.enable = true;
  
    #TODO: users.users.${username} = { extraGroups = [ ]; };
  
    services = {
        # Enable irqbalance service
      irqbalance.enable = true;
        # Enable printing
      printing = { enable = true; drivers = with pkgs; [ ]; };
      dbus.implementation = "broker";
  #    udisks2.enable = true;
        # Enable clipboard manager
      greenclip.enable = true;
      gvfs.enable = true;
      unclutter-xfixes = {
        enable = true;
        extraOptions = [
          "start-hiden"
        ];
      };
      xbanish.enable = true;
    };
      # Enable opengl
    hardware.graphics = {
      enable = true; 
      enable32Bit = true;
    };
  
    services.journald.extraConfig = ''
      systemMaxUse=100M
      MaxFileSec=7day
    '';
  
      # TODO:
    #systemd.tmpfiles.rules = [
      #"d ${archive}/Downloads 0775 ${username} ${group}"
      #"d ${archive}/Music 0775 ${username} ${group}"
      #"d ${archive}/Photos 0775 ${username} ${group}"
      #"d ${archive}/Videos 0775 ${username} ${group}"
    #];
  };

}

