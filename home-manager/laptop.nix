{ lib, ... }: {

  imports = [
    ./pc.nix
    ./qutebrowser
  ];

  modules.device.type = "laptop";

}
