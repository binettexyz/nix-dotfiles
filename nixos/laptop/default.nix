{
  config,
  pkgs,
  lib,
  deviceType,
  ...
}:
{

  imports = [ ./battery.nix ];

  config = lib.mkIf (deviceType == "laptop") {
    laptop.onLowBattery.enable = true;

    # Configure hibernation
    boot.resumeDevice = lib.mkIf (config.swapDevices != [ ]) (
      lib.mkDefault (builtins.head config.swapDevices).device
    );

    # Install laptop related packages
    environment.systemPackages = with pkgs; [
      # iw
      powertop
      acpid
      #     acpi
      brightnessctl
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
      # Enable Blueman to manage Bluetooth
      blueman = {
        enable = true;
      };
      # For battery status reporting
      upower = {
        enable = true;
      };
      # Only suspend on lid closed when laptop is disconnected
      logind = {
        # For hibernate to work you need to set
        # - `boot.resumeDevice` set to the swap partition/partition
        #   containing swap file
        # - If using swap file, also set
        #  `boot.kernelParams = [ "resume_offset=XXX" ]`
        lidSwitch = lib.mkDefault (
          if (config.boot.resumeDevice != "") then "suspend-then-hibernate" else "suspend"
        );
        lidSwitchDocked = lib.mkDefault "ignore";
        lidSwitchExternalPower = lib.mkDefault "lock";
      };

      # Reduce power consumption
      thermald.enable = true;
      auto-cpufreq.enable = true;
      tlp = {
        enable = if config.services.desktopManager.plasma6.enable then false else true;
        settings = {
          # Operation mode when no power supply can be detected: AC, BAT.
          "TLP_DEFAULT_MODE" = "BAT";
          # Operation mode select: 0=depend on power source, 1=always use TLP_DEFAULT_MODE
          "TLP_PERSISTENT_DEFAULT" = 1;
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
          "PCIE_ASPM_ON_AC" = "default";
          "PCIE_ASPM_ON_BAT" = "powersave";
          "START_CHARGE_THRESH_BAT0" = 45;
          "STOP_CHARGE_THRESH_BAT0" = 96;
          "START_CHARGE_THRESH_BAT1" = 45;
          "STOP_CHARGE_THRESH_BAT1" = 96;
          "CPU_SCALING_GOVERNOR_ON_AC" = "performance";
          "CPU_SCALING_GOVERNOR_ON_BAT" = "powersave";
          "ENERGY_PERF_POLICY_ON_AC" = "performance";
          "ENERGY_PERF_POLICY_ON_BAT" = "powersave";
          "CPU_MIN_PERF_ON_AC" = 0;
          "CPU_MAX_PERF_ON_AC" = 90;
          "CPU_MIN_PERF_ON_BAT" = 0;
          "CPU_MAX_PERF_ON_BAT" = 50;
        };
      };
    };
    powerManagement.cpuFreqGovernor = "powersave";
  };
}
