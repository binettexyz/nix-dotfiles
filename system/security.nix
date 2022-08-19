{ config, pkgs, ... }: {

  security = {
      # prevent replacing the running kernel image
    protectKernelImage = true;
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{ users = [ "binette" ]; noPass = true; keepEnv = true; }];
    };
  };

    # GPG
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };
  };


}
