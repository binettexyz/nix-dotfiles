
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/home/default.nix 
    (inputs.impermanence + "/home-manager.nix")
  ];

  modules = {
    packages.enable = false;
#    desktop = {
#      lockscreen.enable = false;
#      xresources.enable = true;

    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = false;
#     xdg.enable = true;
      zsh.enable = true;
    };

    programs = {
     lf.enable = true;
    };
  };

}
