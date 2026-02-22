{ inputs, ... }:
{
  flake.modulesOverlays =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      pkgs_vs = import inputs.vintagestory {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vintagestory" ];
      };
      pkgs_steam = import inputs.steam {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-unwrapped"
          ];
      };
      pkgs_prismlauncher = import inputs.prismlauncher { system = pkgs.stdenv.hostPlatform.system; };
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          unstable = import inputs.unstable { inherit system; };
          stable = import inputs.stable { inherit system; };

          # ---Scripts---
          clipboard = prev.callPackage ./scripts/_clipboard.nix { };
          wofirun = prev.callPackage ./scripts/_wofirun.nix { };
          screenshot = prev.callPackage ./scripts/_screenshot.nix { };
          sysact = prev.callPackage ./scripts/_sysact.nix { };
          # ---Tools---
          anime4k = prev.callPackage ./tools/_anime4k.nix { };
          nix-cleanup = prev.callPackage ./tools/nix-cleanup/_default.nix { };
          nix-rebuild = prev.callPackage ./tools/nix-rebuild/_default.nix { };
          nix-deploy = prev.callPackage ./tools/nix-deploy/_default.nix { };
          # ---Games---
          freedoom = prev.callPackage ./games/_freedoom.nix { };
          moondeck-buddy = prev.callPackage ./games/_moondeck-buddy.nix { };
          steam = pkgs_steam.steam;
          vintagestory = pkgs_vs.vintagestory.overrideAttrs (old: {
            src = pkgs_vs.fetchurl {
              url = old.src.url;
              sha256 = "sha256-LkiL/8W9MKpmJxtK+s5JvqhOza0BLap1SsaDvbLYR0c=";
            };
          });
          prismlauncher = pkgs_prismlauncher.prismlauncher;
          # ---Themes---
          wallpapers = prev.callPackage ./themes/_wallpapers { };
          gruvbox-material-gtk = prev.callPackage ./themes/_gruvbox-material-gtk.nix { };

          lib = prev.lib.extend (
            finalLib: prevLib: (import ../../nix/lib/mkDefaultOption.nix { inherit (prev) lib; })
          );
        })

        (self: super: {
          discord = super.discord.override {
            nss = pkgs.nss_latest;
            withOpenASAR = true;
          };
        })
      ];
    };
}
