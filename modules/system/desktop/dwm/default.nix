{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.windowManager;
  dwm-head = pkgs.callPackage (inputs.dwm + "/default.nix") {};
in
{
  options.modules.windowManager = mkOption {
      description = "Enable DWM";
      type = types.enum [ "dwm" ];
      default = null;
  };

  config = mkIf (cfg == "dwm") {
      # enable suckless window manager
    windowManager.dwm.enable =true;
    home.packages = with pkgs; [ dwm-head ];
};

}
