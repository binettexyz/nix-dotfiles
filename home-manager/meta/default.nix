{ ... }:
{
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  home.stateVersion = "22.11";
}
