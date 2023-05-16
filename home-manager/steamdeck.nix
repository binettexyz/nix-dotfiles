{ config, pkgs, ... }:

{
  imports = [
    ./gaming.nix
    ./minimal.nix
    ./librewolf.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    discord
    solaar
    tidal-hifi
  ];

  programs.zsh.profileExtra =
    let
      inherit (config.home) homeDirectory;
    in
    ''
      # Load nix environment
      if [ -e "${homeDirectory}/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "${homeDirectory}/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
}
