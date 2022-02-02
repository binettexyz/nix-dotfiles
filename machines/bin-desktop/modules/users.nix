{ config, pkgs, lib, ... }: {

  users = {
      # user will be defined in the config only
    defaultUserShell = lib.mkForce pkgs.zsh;
    mutableUsers = false;
    groups.binette.gid = 1000;
    users = {
      root = {
        hashedPassword = "$6$rxT./glTrsUdqrsW$Wzji63op8yTEBoIEcWBc26KOlFJtqx.EKpsGV1A2bQT9oB1JKtrlfdArYICc/Ape.msHcj6ObyXlmRKTWTC/J.";
      };
      binette = {
        uid = 1000;
        isNormalUser = true;
        createHome = true;
        home = "/home/binette";
        group = "binette";
        extraGroups = [ "wheel" "binette" "users" "audio" "video" ];
        hashedPassword = "$6$sXbE2tHuk9pd63mA$B10NqVR9zqwvod5acnGhK0sYPZ3JiV592PYG.DMswbFEgflfR.QOticvEGFMkLvsENsBUWefDOfR26RUxlRHS0";
      };
      cath = {
        isNormalUser = true;
        createHome = true;
        home = "/home/cath";
        group = "users";
        initialPassword = "1234";
      };
    };
  };

   # auto login user on startup
#  services.getty.autologinUser = "binette";

  nix = {
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
  };

}
