{ config, pkgs, ... }: {

  imports = [
    ../../home-manager/meta
    ../../home-manager/neovim
    ../../home-manager/git.nix
    ../../home-manager/ssh.nix
    ../../home-manager/zsh.nix
    ../../home-manager/gaming.nix
    ../../home-manager/librewolf.nix
  ];

  home.packages = with pkgs; [
    zsh
    discord
  ];
}
