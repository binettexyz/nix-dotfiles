{ pkgs, config, lib, ... }:
{
  imports = [
    ./boot
    ./core
    ./laptop
    ./containers
    ./services
    ./desktop
#    ./server
    ./gaming
  ];
}
