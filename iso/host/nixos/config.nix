{ config, pkgs, lib, ... }: with lib; {

  imports = 
    [
      ./options.nix
    ];

  config = {

      # Use less privileged nixos user
    users.users.nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" ];
      # Allow the graphical user to login without password
      initialHashedPassword = "";
    };

      # Allow the user to log in as root without a password.
    users.users.root.initialHashedPassword = "";
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1QoSqbeRihMjTOlRnVIOia/K0FgZvXZlOOJdXDVE54yZ0WxEajYM3n7JgVU+JlvOjUIuzbqLla66YhIG9K2Pixaq4T6PON88aN1E5q2yuJvbu8dNpKrUQY3ZwKbdEzritsJO5YgiC0FqjnllB5SWlu2ZmadXStUV2M2btzqO4v1ZVwEVgJ/cDQe8O7UZWV/jHrPodOWQiTedrFuZPOqmqAcYLV/JEzm6oyxTmhzD6JKsHqjcxM9SAVbqb3TR7/xFzTglnQQ+ueaxcIHnmvSQdR+ii2uFtiNDbtZgQeYk3kZy2gexGrA7MbYb36X/utYKoIlm52GSj1PGGJAN+i0O5jVHIZVi+H4QBVEpaHJ0JucEMq2t3TQb0Uvc9rVxuw8dGxb5rcHmSo4w7hdN1Iwj+KdVv1YaCFoIRUTApTv+3e2fzZuTYXzqTxVKNacKGTXEuTHJ1gMJnOUQqTmeDw3SCUVWlHmyZWQTlIq63Ih50ZPw/e3YnpyYu5feE1m7Y4b0= binette@bin-laptop"
    ];


      # Allow passwordless sudo from nixos user
    security = {
        # prevent replacing the running kernel image
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [{ users = [ "nixos" ]; noPass = true; keepEnv = true; }];
      };
    };

      # Automatically log in at the virtual consoles.
    services.getty.autologinUser = "nixos";

    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
    systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

    # Tell the Nix evaluator to garbage collect more aggressively.
    # This is desirable in memory-constrained environments that don't
    # (yet) have swap set up.
    environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

    # Make the installer more likely to succeed in low memory
    # environments.  The kernel's overcommit heustistics bite us
    # fairly often, preventing processes such as nix-worker or
    # download-using-manifests.pl from forking even if there is
    # plenty of free memory.
    boot.kernel.sysctl."vm.overcommit_memory" = "1";

    # To speed up installation a little bit, include the complete
    # stdenv in the Nix store on the CD.
    system.extraDependencies = with pkgs;
      [
        stdenv
        stdenvNoCC # for runCommand
        busybox
        jq # for closureInfo
      ];

    # Show all debug messages from the kernel but don't log refused packets
    # because we have the firewall enabled. This makes installs from the
    # console less cumbersome if the machine has a public IP.
    networking.firewall.logRefusedConnections = mkDefault false;

    # Prevent installation media from evacuating persistent storage, as their
    # var directory is not persistent and it would thus result in deletion of
    # those entries.
    environment.etc."systemd/pstore.conf".text = ''
      [PStore]
      Unlink=no
    '';
  };
}
