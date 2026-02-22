{ config, lib, ... }:
{
  flake.nixosModules.tmp = {
    boot.tmp = {
      # Mount /tmp using tmpfs for performance
      useTmpfs = lib.mkDefault true;
      tmpfsSize = "50%";
      # If not using above, at least clean /tmp on each boot
      cleanOnBoot = lib.mkDefault true;
    };

    systemd.services.nix-daemon.environment.TMPDIR = "/tmp";
  };
}
