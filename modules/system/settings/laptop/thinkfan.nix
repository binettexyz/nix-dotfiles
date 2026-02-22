{ inputs, ... }:
{
  flake.nixosModules.thinkfan = {
    services.thinkfan = {
      enable = true;
      sensors = [
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/thermal";
          indices = [
            0
            1
            2
          ];
        }
      ];
      fans = [
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/fan";
        }
      ];
      levels = [
        [
          0
          0
          40
        ]
        [
          1
          40
          55
        ]
        [
          2
          55
          60
        ]
        [
          3
          60
          65
        ]
        [
          4
          65
          70
        ]
        [
          5
          70
          72
        ]
        [
          6
          72
          75
        ]
        [
          7
          75
          80
        ]
        [
          "level auto"
          80
          255
        ]
      ];
    };
  };
}
