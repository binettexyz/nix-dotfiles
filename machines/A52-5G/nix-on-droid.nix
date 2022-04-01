{ pkgs, config, lib, homeModules, ... }: {

  user.shell = "${pkgs.zsh}/bin/zsh";

  environment.packages = with pkgs; [

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
    neovim
    lf
    git
    zsh
    openssh
  ];

  home-manager = {
    backupFileExtension = "hm-bak";
    config = { imports = [ ./home/default.nix ]; };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

    # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  system.stateVersion = "21.11";
}
# vim: ft=nix
