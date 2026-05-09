{ writeShellApplication }:
writeShellApplication {
  name = "nix-deploy";
  text = ''
    pushd ~/.config/nixos
    nixos-rebuild "$1" --flake ~/.config/nixos#"$2" --target-host "$2" --build-host "''${3:-$2}" --sudo
    popd
  '';
}
