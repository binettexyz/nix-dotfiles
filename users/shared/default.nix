{ config, pkgs, lib, ... }: {

  users = {
      # user will be defined in the config only
    defaultUserShell = lib.mkForce pkgs.zsh;
    mutableUsers = false;
    users.root = {
      hashedPassword = "$6$rxT./glTrsUdqrsW$Wzji63op8yTEBoIEcWBc26KOlFJtqx.EKpsGV1A2bQT9oB1JKtrlfdArYICc/Ape.msHcj6ObyXlmRKTWTC/J.";
      openssh.authorizedKeys.keys = config.users.users.binette.openssh.authorizedKeys.keys;
    };
  };

  home-manager.useGlobalPkgs = true;

}
