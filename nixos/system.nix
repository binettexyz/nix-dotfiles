{
  config,
  lib,
  deviceType,
  ...
}: let
  inherit (config.meta) username;
in {
  boot = {
    tmp = {
      # Mount /tmp using tmpfs for performance
      useTmpfs = lib.mkDefault true;
      tmpfsSize = "50%";
      # If not using above, at least clean /tmp on each boot
      cleanOnBoot = lib.mkDefault true;
    };
    # Enable NTFS support
    supportedFilesystems = ["ntfs"];
    kernel.sysctl = {
      # Enable Magic keys
      "kernel.sysrq" = 1;
      # Reduce swap preference
      "vm.swappiness" = 10;
    };
    # --Silent boot--
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "console=tty1"
    ];
  };
  # Get rid of defaults packages
  environment.defaultPackages = [];

  # Increase file handler limit
  #    security.pam.loginLimits = [{
  #      domain = "*";
  #      type = "-";
  #      item = "nofile";
  #      value = "524288";
  #    }];

  # Enable firmware-linux-nonfree
  hardware.enableRedistributableFirmware = true;

  services = {
    syncthing = {
      enable = true;
      group = username;
      user = username;
      configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "seiryu" = {id = "44I2ZYQ-QLKB6OI-75TXSDL-AIDJKFR-2DZATQL-2DXEJAL-EKTF274-TF2DCAO";};
          "kokoro" = {id = "GB4UDEE-VJCXPUD-5SSUUGE-IOIR2BK-ISYMLD3-OE3MB2Y-PO5L4CK-4SXCUQD";};
        };
        folders = {
          "Notes" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/${username}/documents/notes"; # Which folder to add to Syncthing
            devices = ["seiryu" "kokoro"]; # Which devices to share the folder with
          };
        };
      };
    };

    #TODO: Trim SSD weekly
    #    fstrim = {
    #      enable = true;
    #      interval = "weekly";
    #    };

    # Decrease journal size
    journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';

    # Suspend when power key is pressed
    logind.powerKey =
      if deviceType == "handheld"
      then "ignore"
      else "suspend";

    # Enable NTP
    timesyncd.enable = lib.mkDefault true;

    # Enable smartd for SMART reporting
    # FIXME:    smartd.enable = true;

    # Set I/O scheduler
    # kyber is set for NVMe, since scheduler doesn't make much sense on it
    # bfq for SATA SSDs/HDDs
    udev.extraRules = ''
      # set scheduler for NVMe
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
      # set scheduler for SSD and eMMC
      ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
      # set scheduler for rotating disks
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    '';
  };

  systemd = {
    # Reduce default service stop timeouts for faster shutdown
    extraConfig = ''
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=5s
    '';
    # systemd's out-of-memory daemon
    oomd = {
      enable = lib.mkDefault true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
    };
  };

  # Enable zram to have better memory management
  #    zramSwap = {
  #      enable = true;
  #      algorithm = "zstd";
  #    };

  # Needed by home-manager's impermanence
  programs.fuse.userAllowOther = true;

  # Sops-nix password encryption
  sops.defaultSopsFile = ../../../secrets/common.yaml;
  sops.age.sshKeyPaths = ["/home/binette/.ssh/id_ed25519"];

  environment.etc = {
    "machine-id".source = "/nix/persist/etc/machine-id";
    "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
  };
}
