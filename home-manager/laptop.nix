{ lib, ... }: {

  imports = [
    ./minimal.nix
    ./lf
    ./mpv
    ./newsboat.nix
    ./pc.nix
    ./qutebrowser
  ];

  modules.device.type = "laptop";

}
