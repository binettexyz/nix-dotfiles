{
  flake,
  lib,
  pkgs,
  system,
  ...
}:
let
  pkgs_vs = import flake.inputs.vintage-story {
    inherit system;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "vintagestory"
      ];
  };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import flake.inputs.unstable {
        inherit system;
      };
      stable = import flake.inputs.stable {
        inherit system;
      };

      # --- Scripts---
      clipboard = prev.callPackage ./scripts/clipboard.nix { };
      wofirun = prev.callPackage ./scripts/wofirun.nix { };
      screenshot = prev.callPackage ./scripts/screenshot.nix { };
      sysact = prev.callPackage ./scripts/sysact.nix { };
      # ---Tools---
      anime4k = prev.callPackage ./tools/anime4k.nix { };
      nix-cleanup = prev.callPackage ./tools/nix-cleanup { };
      #nixos-cleanup = prev.callPackage ./tools/nix-cleanup {isNixOS = true;};
      nix-rebuild = prev.callPackage ./tools/nix-rebuild { };
      # ---Games---
      freedoom = prev.callPackage ./games/freedoom.nix { };
      moondeck-buddy = prev.callPackage ./games/moondeck-buddy.nix { };
      vintagestory = pkgs_vs.vintagestory;
      # ---Themes---
      wallpapers = prev.callPackage ./themes/wallpapers { };
      gruvbox-material-gtk = prev.callPackage ./themes/gruvbox-material-gtk.nix { };

      lib = prev.lib.extend (
        finalLib: prevLib: (import ../lib/mkDefaultOption.nix { inherit (prev) lib; })
      );
    })

    (self: super: {
      discord = super.discord.override {
        nss = pkgs.nss_latest;
        withOpenASAR = true;
      };
    })
  ];
}
