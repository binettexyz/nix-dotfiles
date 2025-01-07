{ ... }: {

  imports = [
    ./bootloader.nix
    ./cli.nix
    ./home.nix
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
