{ pkgs, config, lib, ... }:
{
  imports = [
    ./boot
    ./core
    ./laptop
    ./containers
    ./services
#    ./server
    ./gaming
  ];
}
