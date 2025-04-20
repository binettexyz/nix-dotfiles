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

      clipboard = prev.callPackage ./packages/clipboard.nix { };
      wofirun = prev.callPackage ./packages/wofirun.nix { };
      screenshot = prev.callPackage ./packages/screenshot.nix { };
      sysact = prev.callPackage ./packages/sysact.nix { };
      anime4k = prev.callPackage ./packages/anime4k.nix { };
      freedoom = prev.callPackage ./packages/freedoom.nix { };
      wallpapers = prev.callPackage ./packages/wallpapers { };
      autorandr = prev.autorandr.overrideAttrs (_: {
        src = inputs.autorandr;
      });
      # namespaces
      lib = prev.lib.extend (
        finalLib: prevLib: (import ../lib/mkDefaultOption.nix { inherit (prev) lib; })
      );

      nix-cleanup = prev.callPackage ./packages/nix-cleanup { };
      nixos-cleanup = prev.callPackage ./packages/nix-cleanup { isNixOS = true; };
      nix-rebuild = prev.callPackage ./packages/nix-rebuild { };

      gruvbox-material-gtk = prev.callPackage ./packages/gruvbox-material-gtk.nix { };
    })
    (self: super: {
      discord = super.discord.override {
        nss = pkgs.nss_latest;
        withOpenASAR = true;
      };
    })
  ];
}
