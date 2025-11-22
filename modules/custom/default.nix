{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./customModules.nix
    ./device.nix
  ];
}
