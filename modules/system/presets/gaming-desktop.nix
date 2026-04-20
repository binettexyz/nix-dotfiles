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
      outputCap = 2.0;
      rotation.angle = 5.0;
      mode.synchronous = {
        gamma = 10.0;
        smoothness = 0.5;
        motivity = 4.0;
        syncspeed = 30.0;
      };
    };

    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0c10", MODE="0660", GROUP="binette", TAG+="uaccess", TAG+="udev-acl"
    '';
  };

  flake.modules.homeManager.desktopGamingPreset = {
    imports = with inputs.self.modules.homeManager; [
      graphicalPreset
      gaming
    ];
  };
}
