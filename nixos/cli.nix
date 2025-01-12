{ config, lib, pkgs, ... }: {

  /* ---CLI packages.--- */
  environment = {
    systemPackages = with pkgs; [
      linuxPackages.cpupower
      lm_sensors
    ];
  };

  /* ---Set environment variables--- */
  environment.variables = {
    NIXOS_CONFIG_DIR = "/etc/nixos";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
    TERMINAL = "st";
    BROWSER = "qutebrowser";
    SUDO = "doas";
  };


}
