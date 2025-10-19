{
  lib,
  pkgs,
  flake,
  ...
}: {
  imports = [
    ../custom/default.nix
    ../../overlays
  ];
  # Add some Nix related packages
  environment.systemPackages = [
    pkgs.nix-rebuild
    pkgs.screenshot
    pkgs.sysact
    pkgs.clipboard
    pkgs.wofirun
  ];

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      config = {
        # Avoid git log spam while building this config
        init.defaultBranch = "master";
      };
    };
    # Alternative to nixos-rebuild.
    nh = {
      enable = true;
      flake = "/etc/nixos";
    };
  };

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
    nixPath = [
      "nixpkgs=${flake.inputs.unstable}"
      "nixpkgs-unstable=${flake.inputs.unstable}"
    ];
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Enable unfree packages
  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
    "vintagestory"
    "steam-jupiter-unwrapped"
    "steamdeck-hw-theme"
  ];

  # Change build dir to /var/tmp
  systemd.services.nix-daemon.environment.TMPDIR = "/tmp";

  system.stateVersion = "24.11"; # Did you read the comment?
}
