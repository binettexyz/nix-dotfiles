{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./customModules.nix
    ./device.nix
    ./meta.nix
  ];
}
