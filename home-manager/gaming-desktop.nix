{ config, pkgs, ... }:

{
  imports = [
    ./modules/meta
    ./modules/neovim
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/zsh.nix
    ./modules/lf
    ./modules/gaming
    ./modules/librewolf.nix
  ];

  home.packages = with pkgs; [
  ];

}
