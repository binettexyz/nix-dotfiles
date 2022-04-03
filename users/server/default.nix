{ ... }: {

  users = {
    groups.binette.gid = 1000;
    users.nas = {
      isNormalUser = true;
      uid = 1000;
      createHome = true;
      home = "/home/nas";
      group = "nas";
      extraGroups = [ "wheel" "nas" ];
      description = "Binette's server";
      hashedPassword = "$6$6IblJZVhoX./2Jfa$6cfWUmjJxjkemQS.pMhTOYelFxOiXH3637pKMEfdCnjDdOSZcUvMBIyKwzSY4SJ6e8UtWGBuroNAjRvVZT7Jk1";
      openssh.authorizedKeys.keys = config.users.users.binette.openssh.authorizedKeys.keys;
    };

}
