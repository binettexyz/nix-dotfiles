{...}: {
  imports = [
    ./audio.nix
    ./bootloader.nix
    ./environmentVariables.nix
    ./desktopEnvironment.nix
    ./fonts.nix
    ./gaming.nix
    ./home.nix
    ./laptop
    ./locale.nix
    ./meta.nix
    ./network.nix
    ./security.nix
    ./server
    ./ssh.nix
    ./system.nix
    ./user.nix
  ];
}
