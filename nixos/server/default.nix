{
  config,
  lib,
  deviceType,
  ...
}:
let
  name = "nixbuilder";
in
{

  imports = [ ./containers ];

  config = lib.mkIf (deviceType == "server") {

    # ---Network File System---
    services.nfs.server = {
      enable = true;
      exports = ''
        /media 100.91.89.2(rw,insecure,no_subtree_check)
        /media 100.67.150.87(rw,insecure,no_subtree_check)
      '';
    };

    # ---Docker Container---
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        enableNvidia = lib.mkDefault false;
        autoPrune.enable = true;
      };
      oci-containers.backend = "podman";
    };

    # ---Builder User---
    users = {
      groups.${name} = { };
      users.${name} = {
        useDefaultShell = true;
        #shell = "/run/current-system/sw/bin/nologin";
        isNormalUser = true;
        createHome = true;
        home = "/home/${name}";
        group = "${name}";
        extraGroups = [ "${name}" ];
      };
    };
    security.doas.extraRules = [
      {
        users = [ "nixbuilder" ];
        noPass = true;
        cmd = "nixos-rebuild";
      }
    ];
    nix.settings.trusted-users = [ "${name}" ];

  };
}
