{ config, pkgs, ... }:

{
  imports = [
    ./modules/meta
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/zsh.nix
    ./modules/gaming
    ./modules/librewolf.nix
  ];

  home.packages = with pkgs; [
      # TODO: Setup emulations 
    steam-rom-manager # Tool to add roms to steam
  ];

}
