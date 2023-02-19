{ config, lib, pkgs, ... }: {

  /* ---CLI packages.--- */
  environment = {
    systemPackages = with pkgs; [
      linuxPackages.cpupower
      lm_sensors
    ];
  };

  /* ---Enable programs that need special configuration.--- */
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
      withNodeJs = false;
    };
  };

  /* ---Set environment variables--- */
  environment.variables = {
    NIXOS_CONFIG_DIR = "/etc/nixos";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
    TERMINAL = "st";
    BROWSER = "librewolf";
  };


}
