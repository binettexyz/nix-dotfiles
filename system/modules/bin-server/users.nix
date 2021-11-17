{ config, pkgs, ... }: {

  users.users.binserv = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    home = "/home/binserv";
    hashedPassword = "$6$GAEKk6atuYJ2y$HvJDzPyvv4qy9eaIn239xrFL3NWd5Dd4fb9c84hpCE/8BRrySjH96/vSnI./RYF8RbhAEf4CquwwDN.wtKbJP1";
    description = "Binette's server";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };

    # auto login user on startup
  services.getty.autologinUser = "binserv";

  nix = {
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
  };

}
