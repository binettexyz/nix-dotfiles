{ ... }: {

  imports = [
    ./bootloader.nix
    ./cli.nix
    ./locale.nix
    ./meta.nix
    ./network.nix
    ./security.nix
    ./ssh.nix
    ./system.nix
    ./user.nix
    ../modules
  ];

}
