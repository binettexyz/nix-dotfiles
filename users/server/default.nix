{ ... }: {

  users = {
    groups.nas.gid = 1000;
    users.binette = {
      isNormalUser = true;
      uid = 1000;
      createHome = true;
      home = "/home/binette";
      group = "nas";
      extraGroups = [ "wheel" "nas" ];
      description = "Binette's server";
      hashedPassword = "$6$8axotPZn5X.GYW4q$2fYyekfY5KiF/91E3lfTLXXFGsL4r/hPfzTJz.b4.ei0Z1BZQkJ03.4x2hlgVchaGcrHwlG8f2lrrCa6WJoZK.";
#      openssh.authorizedKeys.keys = config.users.users.binette.openssh.authorizedKeys.keys;
    };
  };

}
