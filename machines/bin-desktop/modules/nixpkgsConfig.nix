{config, pkgs, ... }: {

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    packageOverrides = pkgs: {
        # Nix User Repository
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
        # Nixos Repositories
      unstable = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-unstable.tar.gz") {
        config = config.nixpkgs.config;
      };
      small = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-21.11-small.tar.gz") {
        config = config.nixpkgs.config;
      };
      small-unstable = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-unstable-small.tar.gz") {
        config = config.nixpkgs.config;
      };
        # Suckless Packages
      dwm-head = pkgs.callPackage /home/binette/.git/repos/dwm {};
      st-head = pkgs.callPackage /home/binette/.git/repos/st {};
      dmenu-head = pkgs.callPackage /home/binette/.git/repos/dmenu {};
      slstatus-head = pkgs.callPackage /home/binette/.git/repos/slstatus {};
      surf-head = pkgs.callPackage /home/binette/.git/repos/surf {};
      tabbed-head = pkgs.callPackage /home/binette/.git/repos/tabbed {};

        # nnn
#      nnn = pkgs.callPackage (import ./packages/pkgs/nnn/nnn.nix) {};

     };
  };
}
