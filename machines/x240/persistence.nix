{ config, ... }: {

  programs.fuse.userAllowOther = true;

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/srv"
      "/var/lib"
      "/var/log"
      "/root"
    ];

    users.binette.directories = [
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
    ];
  };

}
