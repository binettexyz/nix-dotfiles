{ pkgs, config, ... }: {

  environment.packages = with pkgs; [

    # Some common stuff that people expect to have
    lf
    neovim
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    openssh
  ];

    # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

    # Read the changelog before changing this value
  system.stateVersion = "21.11";

  home-manager = {
      # If you want the same pkgs instance to be used for nix-on-droid and home-manager
    useGlobalPkgs = true;
    config = { pkgs, lib, ... }: {
           
        # Use the same overlays as the system packages
      nixpkgs = { inherit (config.nixpkgs) overlays; };

        # Read the changelog before changing this value
      home.stateVersion = "21.11";
    };
}
