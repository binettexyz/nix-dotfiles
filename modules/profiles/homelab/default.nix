{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.homelab;
in
{
  options.modules.homelab = {
    enable = lib.mkEnableOption "Enable Homelab's services and configuration variables";
    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "jbinette.xyz";
      description = "Base domain name for my homelab";
    };
  };

  imports = [ ./services ];

  config = {
    # ---Nat---
    networking = {
      firewall.allowedTCPPorts = [
        80
        443
      ];
      nat = {
        enable = true;
        internalInterfaces = [ "ve-+" ];
        externalInterface = "wlan0";
      };
    };
  };
}
