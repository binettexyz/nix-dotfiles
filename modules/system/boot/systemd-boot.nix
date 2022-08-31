{ pkgs, lib, ... }:
with lib;

let
  cfg = config.modules.bootloader;
in
{

  options.modules.bootloader = mkOption {
      description = "Enable Systemd-boot bootloader";
      type = types.enum [ "systemd-boot" ];
      default = null;
  };

  config = mkIf (cfg == "systemd-boot") {

  };

}
