{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./battery.nix ];

  config = lib.mkIf (config.modules.device.type == "laptop") {
    laptop.onLowBattery.enable = true;

    # Configure hibernation
    #FIXME: boot.resumeDevice = "/dev/disk/by-label/swap";

    # Install laptop related packages
    environment.systemPackages = [
      pkgs.powertop
      pkgs.acpid
      pkgs.brightnessctl
    ];

    # Configure special hardware in laptops
    hardware = {
      # Enable bluetooth
      bluetooth = {
        enable = true;
      };
    };

    # Enable laptop specific services
    services = {
      # Device's firmware updater
      fwupd.enable = true;
      # Enable Blueman to manage Bluetooth
      blueman = {
        enable = true;
      };
      # For battery status reporting
      upower = {
        enable = true;
      };
      # Only suspend on lid closed when laptop is disconnected
      logind.settings.Login = {
        HandleLidSwitch = lib.mkDefault "suspend";
        HandleLidSwitchDocked = lib.mkDefault "ignore";
        HandleLidSwitchExternalPower = lib.mkDefault "ignore";
        HandlePowerKey = "suspend";
      };

      # Fans Control
      thinkfan = {
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

      # Reduce power consumption
      thermald.enable = true;
      tlp = {
        enable = if config.services.desktopManager.plasma6.enable then false else true;
        settings = {
          # Operation mode when no power supply can be detected: AC, BAT.
          "TLP_DEFAULT_MODE" = "BAT";
          # Operation mode select: 0=depend on power source, 1=always use TLP_DEFAULT_MODE
          #"TLP_PERSISTENT_DEFAULT" = 1;
          # Disable too aggressive power-management autosuspend for USB receiver for wireless mouse
          "USB_AUTOSUSPEND" = 0;
          # Exclude audio devices from autosuspend mode
          "USB_EXCLUDE_AUDIO" = 0;
          # Timeout (in seconds) for the audio power saving mode
          # 1 is recommended with PulseAudio
          # 10 may be required without PulseAudio.
          # The value 0 disables power save.
          # https://lists.freedesktop.org/archives/pulseaudio-discuss/2017-December/029154.html
          "SOUND_POWER_SAVE_ON_AC" = 1;
          "SOUND_POWER_SAVE_ON_BAT" = 1;
          #          "PCIE_ASPM_ON_AC" = "default";
          #          "PCIE_ASPM_ON_BAT" = "powersave";
          "START_CHARGE_THRESH_BAT0" = 80;
          "START_CHARGE_THRESH_BAT1" = 80;
          "STOP_CHARGE_THRESH_BAT0" = 85;
          "STOP_CHARGE_THRESH_BAT1" = 85;
          "CPU_BOOST_ON_AC" = 1;
          "CPU_BOOST_ON_BAT" = 0;
          "CPU_SCALING_GOVERNOR_ON_AC" = "performance";
          "CPU_SCALING_GOVERNOR_ON_BAT" = "powersave";
          "ENERGY_PERF_POLICY_ON_AC" = "performance";
          "ENERGY_PERF_POLICY_ON_BAT" = "powersave";
          "CPU_ENERGY_PERF_POLICY_ON_AC" = "performance";
          "CPU_ENERGY_PERF_POLICY_ON_BAT" = "power";
          "CPU_MIN_PERF_ON_AC" = 100;
          "CPU_MAX_PERF_ON_AC" = 100;
          "CPU_MIN_PERF_ON_BAT" = 0;
          "CPU_MAX_PERF_ON_BAT" = 100;
          "PLATFORM_PROFILE_ON_AC" = "performance";
          "PLATFORM_PROFILE_ON_BAT" = "low-power";
        };
      };
    };
  };
}
