{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.windowManager;
in
{
  options.modules.windowManager = mkOption {
      description = "Enable DWM";
      type = with types; nullOr (enum [ "dwm" ]);
      default = null;
  };

  config = mkIf (cfg == "dwm") {
      # enable suckless window manager
    services.xserver.windowManager.dwm.enable = true;
    environment.systemPackages = with pkgs; [ dwm-head ];
  };

}
