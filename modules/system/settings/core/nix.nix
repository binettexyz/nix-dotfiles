{
  flake.nixosModules.nix = {
    nix = {
      settings = {
        sandbox = true;
        auto-optimise-store = true;
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      daemonIOSchedClass = "idle";
      daemonCPUSchedPolicy = "idle";
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
    };
  };
}
