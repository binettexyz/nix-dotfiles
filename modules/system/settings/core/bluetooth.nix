{

  flake.nixosModules.bluetooth =
    { config, ... }:
    {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = if (config.modules.device.type == "laptop") then true else false;

      environment.persistence."/nix/persist".directories = [ "/var/lib/bluetooth" ];
    };
}
