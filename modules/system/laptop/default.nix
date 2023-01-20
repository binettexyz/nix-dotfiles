{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.laptop;
in
{
  imports = [
    ./battery
  ];

  options.modules.profiles.laptop = {
    enable = mkOption {
      description = "Whether to enable laptop settings. Also tags laptop for user settings";
      type = types.bool;
      default = false;
    };

    fprint = {
      enable = mkOption {
        description = "Enable fingerprint";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ({

      laptop.onLowBattery.enable = true;

      powerManagement.cpuFreqGovernor = "powersave";

      services = {
        thermald.enable = true;
        auto-cpufreq.enable = true;
        tlp = {
          enable = if config.services.xserver.desktopManager.plasma5.enable then false else true;
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

      environment = {
        systemPackages = with pkgs; [
          powertop
           acpid
#          acpi
          brightnessctl
        ];
      };

      services.logind = {
          # Specifies what to do when the laptop lid is closed and the system is on external power.
        lidSwitchExternalPower = config.services.logind.lidSwitch;
          # Specifies what to be done when the laptop lid is closed and another screen is added.
        lidSwitchDocked = "ignore";
          # Specifies what to be done when the laptop lid is closed. 
        lidSwitch = "ignore";
        extraConfig = ''
          HandleSuspendKey=ignore
        '';
      };
    })
    (mkIf cfg.fprint.enable {
      services.fprintd.enable = true;
    })
  ]);

}

