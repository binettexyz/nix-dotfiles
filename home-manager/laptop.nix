{ lib, ... }: {

  imports = [
    ./modules/pc.nix
    ./modules/qutebrowser
  ];

  device.type = "laptop";

}
