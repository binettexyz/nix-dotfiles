{ config, pkgs, ... }: {

    # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.binette = {
    isNormalUser = true;
    shell = pkgs.zsh;
    home = "/home/binette";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };
     
   # auto login user on startup
#  services.getty.autologinUser = "binette";

  nix = {
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
  };

}
