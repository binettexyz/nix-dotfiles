{ pkgs, config, lib, ... }:
{
  imports = [
    ./boot
    ./core
    ./laptop
    ./services
    ./desktop
    ./server
    ./gaming
  ];
}
