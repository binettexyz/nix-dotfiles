{
  flake.nixosModules.firmware =
    { config, lib, ... }:
    let
      cfg = config.modules.device;
    in
    {
      #hardware.enableAllFirmware = true;
      hardware.enableRedistributableFirmware = true;
      hardware.cpu.${cfg.cpu}.updateMicrocode = true;
      services.fwupd.enable = lib.mkIf (cfg.type == "laptop") true;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}
