{ config, pkgs, ... }: {

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      sandbox = true;
      trusted-users = [ "@wheel" ];
      allowed-users = [ "@wheel" ];
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

    system = {
      autoUpgrade = {
        enable = true;
        allowReboot = false;
        channel = https://github.com/NixOS/nixpkgs/archive/master.tar.gz;
      };
    };


}
