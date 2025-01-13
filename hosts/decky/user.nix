{ config, pkgs, ... }: {

  imports = [ ../../home-manager/meta ];

  home.packages = with pkgs; [ zsh ];
}
