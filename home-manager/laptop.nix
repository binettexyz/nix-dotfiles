{ lib, ... }: {

  imports = [
    ./pc.nix
    ./qutebrowser
  ];

  device.type = "laptop";

}
