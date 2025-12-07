{ writeShellApplication }:
writeShellApplication {
  name = "nix-rebuild";
  text = ''
    pushd /etc/nixos
    unbuffer nixos-rebuild "$@" --flake .# --sudo |& nom
    popd
  '';
}
