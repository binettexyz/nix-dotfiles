{ inputs, ... }:
{
  flake.nixosModules.minimalPreset = {
    imports =
      with inputs.self.nixosModules;
      [
        bootloader
        environmentVariables
        firmware
        locale
        meta
        network
        nix
        secrets
        security
        ssh
        storage
        systemd
        tmp
      ]
      ++ [ inputs.self.modulesOverlays ]
      ++ (with inputs.self.modules.generic; [
        custom
        device
      ]);
  };

  flake.modules.homeManager.minimalPreset = {
    imports =
      with inputs.self.modules.homeManager;
      [
        colorScheme
        #        git
        meta
        secrets
        ssh
      ]
      ++ (with inputs.self.modules.generic; [
        custom
        device
      ]);
  };
}
