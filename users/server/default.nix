{ ... }: {

  users.users.nas = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/nas";
    hashedPassword = "$6$6IblJZVhoX./2Jfa$6cfWUmjJxjkemQS.pMhTOYelFxOiXH3637pKMEfdCnjDdOSZcUvMBIyKwzSY4SJ6e8UtWGBuroNAjRvVZT7Jk1";
    description = "Binette's server";
    extraGroups = [ "wheel" "nas" ];
  };

}
