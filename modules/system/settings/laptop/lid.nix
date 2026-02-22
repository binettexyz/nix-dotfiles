{
  flake.nixosModules.lid =
    { lib, ... }:
    {
      # Enable laptop specific services
      services = {
        # Only suspend on lid closed when laptop is disconnected
        logind.settings.Login = {
          HandleLidSwitch = lib.mkDefault "suspend";
          HandleLidSwitchDocked = lib.mkDefault "suspend";
          HandleLidSwitchExternalPower = lib.mkDefault "suspend";
          HandlePowerKey = "suspend";
        };
      };
    };
}
