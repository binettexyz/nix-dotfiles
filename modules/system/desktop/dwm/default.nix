{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.windowManager;
  dwm-head = pkgs.callPackage (inputs.dwm + "/default.nix") {};
in
{
  options.modules.windowManager = mkOption {
      description = "Enable DWM";
      type = types.enum [ "dwm" "null" ];
      default = null;
  };

  config = mkIf (cfg == "dwm") {
      # enable suckless window manager
    services.xserver.windowManager.dwm.enable =true;
    environment.systemPackages = with pkgs; [ dwm-head ];
};

}
