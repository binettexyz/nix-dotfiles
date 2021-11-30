{ config, pkgs, ... }: {

  users = {
      # user will be defined in the config only
    mutableUsers = false;
    users.binette = {
      isNormalUser = true;
      uid = 1000;
      shell = pkgs.zsh;
      home = "/home/binette";
      hashedPassword = "$6$btbSeYs4f.xm$sIxwff41bBwbThewVWnK9D5.TMWx2Bx4H2C0/NtPdWU4K9XEP1pRfCt.8z5axaOIAaRakgEIOXH3KDqM.MYef.";
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    };
  };

   # auto login user on startup
#  services.getty.autologinUser = "binette";

  nix = {
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
  };

}
