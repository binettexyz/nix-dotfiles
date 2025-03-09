{ config, pkgs, lib, ... }:

with lib; {
  options.device = {
    type = mkOption {
      type = types.enum [ "desktop" "gaming-handheld" "gaming-desktop" "laptop" "server" "vm" ];
      description = "Type of device";
      default = "";
    };
    hasBattery = mkOption {
      description = "Device has battery";
      default = false;
    };
    gpu = mkOption {
      type = types.enum [ "amd" "nvidia" ];
      description = "Type of graphic cards";
      default = "";
    };
    ssd.enable = mkOption {
      description = "type of hard drive";
      type = types.bool;
      default = false;
    };
    netDevices = mkOption {
      type = with types; (listOf str);
      description = "Available net devices";
      example = [ "eno1" "wlp2s0" ];
      default = [ "eth0" ];
    };
    mountPoints = mkOption {
      type = with types; (listOf str);
      description = "Available mount points";
      example = [ "/" "/mnt/backup" ];
      default =
        if (config ? fileSystems) then
          (lists.subtractLists [ "/boot" "/tmp" "/nix" ]
            (mapAttrsToList (n: _: n) config.fileSystems))
        else
          [ "/" ];
    };
  };
}
