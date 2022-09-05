
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/home/default.nix 
    (inputs.impermanence + "/home-manager.nix")
  ];

  modules = {
    packages.enable = false;

    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = false;
      xdg.enable = true;
      xresources = null;
      zsh.enable = true;
    };

    programs = {
     lf.enable = true;
    };
  };

}
