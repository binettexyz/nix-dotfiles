{ config, flake, lib, pkgs, ... }:
with lib;
let
  inherit (flake) inputs;
  cfg = config.modules.system.desktopEnvironment.default;
in
  {
    /* ---Desktop Environment Module--- */
    options.modules.system.desktopEnvironment = {
      default = mkOption {
        description = "Enable Desktop Environment";
        type = with types; nullOr (enum [ "plasma" "gnome" "gamescope-wayland" ]);
        default = null;
      };
      jovian-nixos.enable = mkOption {
        description = "Enable Jovian-NixOS features.";
        default = false;
      };
    };

    /* ---Configuration--- */
    config = mkMerge [
      (mkIf (cfg == "plasma") {
        services.xserver.displayManager.sx.enable = lib.mkForce false;
        services.desktopManager.plasma6.enable = true;
        services.displayManager = {
          sddm.enable = if config.modules.system.desktopEnvironment.jovian-nixos.enable then false else true;
          defaultSession = "plasma";
        };
        environment.plasma6.excludePackages = with pkgs.libsForQt5; [
          elisa
          khelpcenter
          oxygen
          discover
          ark
        ];

        environment.systemPackages = with pkgs; [ kdePackages.ark ];
      })
      (mkIf (cfg == "gnome") {
        services.xserver.displayManager.sx.enable = lib.mkForce false;
        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.displayManager = {
          gdm.enable = if config.modules.system.desktopEnvironment.jovian-nixos.enable then false else true;
          defaultSession = "gnome";
        };
        environment.gnome.excludePackages = with pkgs.libsForQt5; [
          baobab
          epiphany
          gnome-text-editor
          gnome-clocks
          gnome-contacts
          gnome-font-viewer
          gnome-logs
          gnome-maps
          gnome-music
          gnome-weather
          gnome-loop
          gnome-connections
          simple-scan
          gnome-snapshot
          gnome-totem
          gnome-yelp
          seahorse
          geary
          gnome-disks
          file-roller
          gnome-tour
        ];
      })
    ];
  }
