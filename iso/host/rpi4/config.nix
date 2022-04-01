{ lib, config, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix>
  ];

  users.users.nixos.initialPassword = "nixos";

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    git
    lf
    neovim
    wipe
  ];

        # Allow passwordless sudo from nixos user
    security = {
        # prevent replacing the running kernel image
      sudo.enable = lib.mkForce false;
      doas = {
        enable = true;
        extraRules = [{ users = [ "nixos" ]; noPass = true; keepEnv = true; }];
      };
    };

}
