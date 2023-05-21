{ pkgs, flake, ... }:
let
  inherit (flake) inputs;
in {

  # Enable Flakes
  settings = import ./nix-conf.nix;

    # Nix auto cleanup and reduce disk
  gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

    # Leave nix builds as a background task
  daemonIOSchedClass = "idle";
  daemonCPUSchedPolicy = "idle";

  # Set the $NIX_PATH entry for nixpkgs. This is necessary in
  # this setup with flakes, otherwise commands like `nix-shell
  # -p pkgs.htop` will keep using an old version of nixpkgs
  nixPath = [
    "nixpkgs=${inputs.stable}"
    "nixpkgs-unstable=${inputs.unstable}"
  ];

  # Useful for nix-direnv, however not sure if this will
  # generate too much garbage
  extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # Same as above, but for `nix shell nixpkgs#htop`
  # FIXME: for non-free packages you need to use `nix shell --impure`
  registry = {
    nixpkgs.flake = inputs.stable;
    nixpkgs-unstable.flake = inputs.unstable;
  };
}
