{

  flake.nixosModules.bluetooth =
    { config, lib, ... }:
    {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable =
        config.modules.device.type != "server" && !(lib.elem "console" config.modules.device.tags);

      environment.persistence."/nix/persist".directories = [ "/var/lib/bluetooth" ];
    };
}
