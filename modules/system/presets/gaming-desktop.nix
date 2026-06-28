{ inputs, ... }:
{
  flake.nixosModules.desktopGamingPreset = {
    imports =
      with inputs.self.nixosModules;
      [
        gaming
        graphicalPreset
      ]
      ++ [ inputs.yeetmouse.nixosModules.default ];

    ## Mouse Acceleration ##
    hardware.yeetmouse = {
      enable = true;
      sensitivity = 1.65;
      outputCap = 1.5;
      preScale = 0.5;
      rotation.angle = 5.0;
      mode.synchronous = {
        gamma = 10.0;
        smoothness = 0.5;
        motivity = 4.0;
        syncspeed = 20.0;
      };
    };

    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

  };

  flake.modules.homeManager.desktopGamingPreset = {
    imports = with inputs.self.modules.homeManager; [
      graphicalPreset
      emulation
      gaming
    ];
  };
}
