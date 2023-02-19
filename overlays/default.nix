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
      anime4k = prev.callPackage ../packages/anime4k { };
      #st = prev.st.overrideAttrs (old: { src = inputs.st + "/default.nix" ;});
        # namespaces
      lib = prev.lib.extend (finalLib: prevLib:
        (import ../modules/mkDefaultOption.nix { inherit (prev) lib; })
      );
    })
    (self: super: {
      discord-canary-openasar = super.discord.override { 
        /*nss = pkgs.nss_latest;*/ withOpenASAR = true; };
    })
  ];
}
