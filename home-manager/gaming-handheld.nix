{ config, pkgs, ... }:

{
  imports = [ ./modules ];

  modules.hm = {
    gaming.enable = true;
    browser = { librewolf.enable = true; };
  };

  home.packages = with pkgs; [
      # TODO: Setup emulations 
    steam-rom-manager # Tool to add roms to steam
  ];

}
