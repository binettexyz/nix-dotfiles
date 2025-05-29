{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./device.nix
    ./meta.nix
  ];
}
