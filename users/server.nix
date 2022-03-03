{ ... }: {

  users.users.server = {
    isNormalUser = true;
    uid = 1001;
    home = "/home/server";
    hashedPassword = "$6$6IblJZVhoX./2Jfa$6cfWUmjJxjkemQS.pMhTOYelFxOiXH3637pKMEfdCnjDdOSZcUvMBIyKwzSY4SJ6e8UtWGBuroNAjRvVZT7Jk1";
    description = "Binette's server";
    extraGroups = [ "wheel" "server" ];
  };

}
