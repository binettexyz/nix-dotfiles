{ pkgs, config, lib, ... }:
with lib;

{

    programs.git = {
      enable = true;
      userName = "binettexyz";
      userEmail = "binettexyz@proton.me";
      aliases = {
      };
    };

}
