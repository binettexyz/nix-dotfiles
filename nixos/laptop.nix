{ config, flake, lib, pkgs, ... }: {

  imports = [
    ./modules
  ];

  device.type = "laptop";
  modules.system = {
    audio.enable = true;
    customFonts.enable = true;
    desktopEnvironment = { default = null; };
    home.enable = true;
  };

}
