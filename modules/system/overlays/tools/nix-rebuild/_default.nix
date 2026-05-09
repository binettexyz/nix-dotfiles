{ writeShellApplication }:
writeShellApplication {
  name = "nix-rebuild";
  text = ''
    pushd ~/.config/nixos
    unbuffer nixos-rebuild "$@" --flake ~/.config/nixos# --sudo |& nom
    popd
  '';
}
