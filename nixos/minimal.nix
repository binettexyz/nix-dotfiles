{ ... }: {

  imports = [
    ./bootloader.nix
    ./cli.nix
    ./locale.nix
    ./meta.nix
    ./network.nix
    ./security.nix
    #./server
    ./ssh.nix
    ./system.nix
    ./user.nix
    ../modules
  ];

}
