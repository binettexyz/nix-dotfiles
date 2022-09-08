
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/home/default.nix 
  ];

  modules = {
    packages.enable = false;
    impermanence.enable = true;

    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = false;
      xdg.enable = false;
      xresources = null;
      zsh.enable = true;
    };

    programs = {
     lf.enable = true;
    };
  };

}
