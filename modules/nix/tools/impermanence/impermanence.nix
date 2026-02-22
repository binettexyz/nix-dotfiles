{ inputs, ... }:
{
  flake.nixosModules.impermanence = {
    imports = [ inputs.impermanence.nixosModules.impermanence ];
    programs.fuse.userAllowOther = true;

    environment.persistence."/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/lib"
        "/var/log"
        "/root"
        "/srv"
      ];
      files = [
        #        "/etc/machine-id"
        #        "/etc/ssh/ssh_host_rsa_key"
        #        "/etc/ssh/ssh_host_rsa_key.pub"
        #        "/etc/ssh/ssh_host_ed25519_key"
        #        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };

  flake.modules.homeManager.impermanence = {
    home.persistence."/nix/persist" = { };
  };
}
