{ config, pkgs, lib, ... }: {

  imports =
   [
     ../modules/zsh
     ../modules/neovim
     ../modules/containers
     ../modules/transmission
     ../users/server
     ../users/shared
    ];


      # don't install documentation i don't use
    documentation.enable = lib.mkForce false; # documentation of packages
    documentation.nixos.enable = lib.mkForce false; # nixos documentation
    documentation.man.enable = lib.mkForce false; # manual pages and the man command
    documentation.info.enable = lib.mkForce false; # info pages and the info command
    documentation.doc.enable = lib.mkForce false; # documentation distributed in packages' /share/doc


}
