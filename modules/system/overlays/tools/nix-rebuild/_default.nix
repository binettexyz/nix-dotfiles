{ writeShellApplication }:
writeShellApplication {
  name = "nix-rebuild";
  text = ''
    pushd ~/.config/nixos
    unbuffer nixos-rebuild "$@" --flake .# --sudo |& nom
    popd
  '';
}
