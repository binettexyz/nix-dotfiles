{
  flake.nixosModules.battery =
    { lib, pkgs, ... }:
    {
      services.udev.extraRules = ''
        SUBSYSTEM=="power_supply", \
        ATTR{status}=="Discharging", \
        ATTR{capacity}=="[0-5]", \
        RUN+="${pkgs.systemd}/bin/systemctl hibernate"
      '';
    };
}
