{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../home-manager/server.nix 
    (inputs.impermanence + "/home-manager.nix")
  ];

  home.persistence = {
    "/nix/persist/home/binette" = {
      removePrefixDirectory = false;
      allowOther = true;
      directories = [
#        ".config/sops"
#        ".zplug"
#        ".local/share/xorg"
#        ".ssh"
#        ".gnupg"
      ];
#      files = [
#        ".local/share/history"
#      ];
    };
  };

}
