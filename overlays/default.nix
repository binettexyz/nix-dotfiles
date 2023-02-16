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
      dwm = prev.dwm.overrideAttrs (old: { src = inputs.dwm ;});
      st = prev.st.overrideAttrs (old: { src = inputs.st ;});
      dmenu = prev.dmenu.overrideAttrs (old: { src = inputs.dmenu ;});
      slstatus-desktop = prev.slstatus.overrideAttrs (old: { src = inputs.slstatus-desktop ;});
      slstatus-laptop = prev.slstatus.overrideAttrs (old: { src = inputs.slstatus-laptop ;});
    })
    (self: super: {
      discord-canary-openasar = super.discord.override { 
        /*nss = pkgs.nss_latest;*/ withOpenASAR = true; };
    })
  ];
}
