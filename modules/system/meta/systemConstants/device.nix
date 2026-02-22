{
  flake.modules.generic.device =
    { lib, ... }:
    {
      options.modules.device = {
        cpu = lib.mkOption {
          type = lib.types.enum [
            "amd"
            "intel"
          ];
          default = "";
        };
        gpu = lib.mkOption {
          type = lib.types.enum [
            "amd"
            "intel"
            "nvidia"
          ];
        };
        hostname = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
        type = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
        tags = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
        hasBattery = lib.mkOption {
          description = "Device has battery";
          default = false;
        };
        videoOutputs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Video output for each screens";
          default = null;
        };
        storage = {
          ssd = lib.mkOption {
            description = "If ssd is installed";
            type = lib.types.bool;
            default = false;
          };
          hdd = lib.mkOption {
            description = "If hdd is installed";
            type = lib.types.bool;
            default = true;
          };
        };
        network.ipv4 = {
          internal = lib.mkOption {
            description = "Declare internal ipv4 adresses";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          tailscale = lib.mkOption {
            description = "Declare tailscale ipv4 adresses";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      };
    };
}
