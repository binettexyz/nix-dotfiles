{ writeShellApplication }:
writeShellApplication {
  name = "nix-deploy";
  text = ''
    pushd /etc/nixos
    nixos-rebuild "$1" --flake .#"$2" --target-host "$2" --build-host "''${3:-''$2}" --sudo
    popd
  '';
}
