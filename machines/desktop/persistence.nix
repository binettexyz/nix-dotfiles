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

    users.binette = {
      directories = [
        ".config/discordcanary"
        ".config/powercord"
        ".config/tidal-hifi"
        ".steam"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];
      files = [
        ".nvidia-settings-rc"
#        ".steampath"
#        ".steampid"
      ];
    };
  };
}
