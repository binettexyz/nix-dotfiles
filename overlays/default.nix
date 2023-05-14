{ inputs, lib, nixpkgs, unstable, pkgs, system, ... }:
let

  overlay-stable = self: super: {
    stable = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowBroken = true;
    };
  };

  overlay-unstable = self: super: {
    unstable = import unstable {
      inherit system;
      config.allowUnfree = true;
      config.allowBroken = true;
    };
  };

in {


  nixpkgs.overlays = [
    overlay-stable
    overlay-unstable
    (final: prev: {
      anime4k = prev.callPackage ../packages/anime4k.nix { };
      wallpapers = prev.callPackage ../packages/wallpapers { };
      dmenu = prev.callPackage (inputs.dmenu + "/default.nix") {};
      dwm = prev.callPackage (inputs.dwm + "/default.nix") {};
      st = prev.callPackage (inputs.st + "/default.nix") {};
        # namespaces
      lib = prev.lib.extend (finalLib: prevLib:
        (import ../modules/mkDefaultOption.nix { inherit (prev) lib; })
      );

      change-res = prev.callPackage ../packages/change-res { };

      nix-cleanup = prev.callPackage ../packages/nix-cleanup { };

      nixos-cleanup = prev.callPackage ../packages/nix-cleanup { isNixOS = true; };

      nom-rebuild = prev.callPackage ../packages/nom-rebuild { };
    })
    (self: super: {
      discord = super.discord.override { 
        nss = pkgs.nss_latest; withOpenASAR = true; };
    })
  ];
}
