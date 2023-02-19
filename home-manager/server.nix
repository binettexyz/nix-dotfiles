{ ... }: {

  imports = [
    ./minimal.nix
    ./lf
  ];

  modules.device.type = "server";

}
