{ lib, ... }: {

  imports = [
    ./minimal.nix
    ./modules/pc.nix
    ./modules/qutebrowser
  ];

  device.type = "laptop";

}
