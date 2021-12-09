{ config, pkgs, ... }: {

  users = {
      # user will be defined in the config only
    mutableUsers = true;
    users.binette = {
      isNormalUser = true;
      uid = 1000;
      shell = pkgs.zsh;
      home = "/home/binette";
      extraGroups = [ "wheel" "audio" "video" ];
    };
  };

   # auto login user on startup
#  services.getty.autologinUser = "binette";

  nix = {
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
  };

}
