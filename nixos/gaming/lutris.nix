{ config, pkgs, lib, ... }: {

  options.gaming.lutris.enable = pkgs.lib.mkDefaultOption "Lutris game installer.";

  config = lib.mkIf config.gaming.lutris.enable {
    environment.systemPackages = with pkgs; [
      lutris
      #(lutris.override { lutris-unwrapped = lutris-unwrapped.override {
        #wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
      #};})
      amdvlk # Vulkan drivers (probably already installed)
      wineWowPackages.stable # 32-bit and 64-bit wineWowPackages
      winetricks
    ];
  };

}
