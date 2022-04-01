{ config, pkgs, ... }: {

  nix = {
#    package = pkgs.nixFlakes;
    useSandbox = true;
    trustedUsers = [ "@wheel" ];
    allowedUsers = [ "@wheel" "cath" ];
    extraOptions = ''
#      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    autoOptimiseStore = true;
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
        channel = https://nixos.org/channels/nixos-21.11;
      };
    };


}
