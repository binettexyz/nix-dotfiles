{
  flake,
  lib,
  pkgs,
  system,
  ...
}:
let
  pkgs_vs = import flake.inputs.vintagestory {
    inherit system;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "vintagestory"
        "steam"
        "steam-unwrapped"
      ];
  };
  pkgs_steam = import flake.inputs.steam {
    inherit system;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "vintagestory"
        "steam"
        "steam-unwrapped"
      ];
  };
  pkgs_prismlauncher = import flake.inputs.prismlauncher {
    inherit system;
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
      nix-deploy = prev.callPackage ./tools/nix-deploy { };
      # ---Games---
      freedoom = prev.callPackage ./games/freedoom.nix { };
      moondeck-buddy = prev.callPackage ./games/moondeck-buddy.nix { };
      steam = pkgs_steam.steam;
      vintagestory = pkgs_vs.vintagestory.overrideAttrs (old: {
        src = pkgs_vs.fetchurl {
          url = old.src.url;
          sha256 = "sha256-LkiL/8W9MKpmJxtK+s5JvqhOza0BLap1SsaDvbLYR0c=";
        };
      });
      prismlauncher = pkgs_prismlauncher.prismlauncher;
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
