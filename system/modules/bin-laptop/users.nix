{ config, pkgs, ... }: {

  users.users.binette = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    home = "/home/binette";
    hashedPassword = "$6$GAEKk6atuYJ2y$HvJDzPyvv4qy9eaIn239xrFL3NWd5Dd4fb9c84hpCE/8BRrySjH96/vSnI./RYF8RbhAEf4CquwwDN.wtKbJP1";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };

   # auto login user on startup
#  services.getty.autologinUser = "binette";

  nix = {
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
  };

}
