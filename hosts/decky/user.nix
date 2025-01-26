{ config, pkgs, ... }: {

  imports = [
    ../../home-manager/meta
    ../../home-manager/neovim
    ../../home-manager/git.nix
    ../../home-manager/ssh.nix
    ../../home-manager/zsh.nix
    ../../home-manager/lf
    ../../home-manager/gaming
    ../../home-manager/librewolf.nix
  ];

}
