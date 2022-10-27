{ inputs, config, pkgs, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.gaming.launchers.lutris;
in
{

  options.modules.profiles.gaming.launchers.lutris.enable = mkEnableOption "Lutris";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      (lutris.override { lutris-unwrapped = lutris-unwrapped.override { wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg; }; })
      amdvlk # Vulkan drivers (probably already installed)
      dxvk
      wineWowPackages.stable # 32-bit and 64-bit wineWowPackages
        # League of Legends
      vulkan-tools
      openssl
      gnome.zenity
    ];

    # ---League of Legends--- #
    boot.kernel.sysctl = { "abi.vsyscall32" = 0; }; # anti-cheat requirement
    environment.sessionVariables = { QT_X11_NO_MITSHM = "1"; };
  };

}
