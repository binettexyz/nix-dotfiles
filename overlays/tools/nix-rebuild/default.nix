{writeShellApplication}:
writeShellApplication {
  name = "nix-rebuild";
  text = ''
    pushd /etc/nixos; doas nixos-rebuild "$@" --flake .#; popd #|& nom
  '';
}
