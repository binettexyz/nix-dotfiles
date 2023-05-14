{ config, lib, pkgs, flake, ... }:
with lib;
{

  imports = [
    ./pc.nix
  ];

  options.gaming.enable = pkgs.lib.mkDefaultOption "gaming Packages";

  config = (mkMerge [
    ({

      home.packages = with pkgs; [
        (calibre.override { unrarSupport = true; })
        discord
        #easyeffects
        #gimp
        #inkscape
        mcrcon
        #FIXME:overlay- open-browser
        pinta
        solaar
        tidal-hifi
      ];
    })
      (mkIf config.gaming.enable {
        home.packages = with pkgs; [
          #prismlauncher
          #grapejuice
          #mangohud # afterburner like
          #runescape runelite
          #zeroad
          #yuzu-mainline
        ];
      })
    
      (mkIf (config.modules.devices.type == "laptop") {
      })
        #inputs.nix-gaming.packages.${pkgs.system}.osu-stable
        #inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ]);

  }

