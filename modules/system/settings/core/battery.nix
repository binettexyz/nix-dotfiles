{ inputs, ... }:
{

  flake.nixosModules.battery =
    { lib, pkgs, ... }:
    {
      services.udev.extraRules = lib.concatStrings [
        ''SUBSYSTEM=="power_supply", ''
        ''ATTR{status}=="Discharging", ''
        ''ATTR{capacity}=="[0-8]", ''
        ''RUN+="${pkgs.systemd}/bin/systemctl hibernate"''
      ];
    };
}
