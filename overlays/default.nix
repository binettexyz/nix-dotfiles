{
  flake,
  pkgs,
  system,
  ...
}:
let
  inherit (flake) inputs;
in
{

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import flake.inputs.unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
      stable = import flake.inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };

      anime4k = prev.callPackage ./packages/anime4k.nix { };
      freedoom = prev.callPackage ./packages/freedoom.nix { };
      wallpapers = prev.callPackage ./packages/wallpapers { };
      autorandr = prev.autorandr.overrideAttrs (_: {
        src = inputs.autorandr;
      });
      dmenu = prev.callPackage (inputs.dmenu + "/default.nix") { };
      dwm = prev.callPackage (inputs.dwm + "/default.nix") { };
      st = prev.callPackage (inputs.st + "/default.nix") { };
      # namespaces
      lib = prev.lib.extend (
        finalLib: prevLib: (import ../lib/mkDefaultOption.nix { inherit (prev) lib; })
      );

      change-res = prev.callPackage ./packages/change-res { };
      nix-cleanup = prev.callPackage ./packages/nix-cleanup { };
      nixos-cleanup = prev.callPackage ./packages/nix-cleanup { isNixOS = true; };
      nix-rebuild = prev.callPackage ./packages/nix-rebuild { };
    })
    (self: super: {
      discord = super.discord.override {
        nss = pkgs.nss_latest;
        withOpenASAR = true;
      };
    })
  ];
}
