{
  config,
  lib,
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
#    initrd.verbose = false;
#    consoleLogLevel = 0;
#    kernelParams = [
#      "quiet"
#      "loglevel=3"
#      "rd.systemd.show_status=false"
#      "rd.udev.log_level=3"
#      "udev.log_priority=3"
#    ];
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
      dataDir = "/home/${username}/.local/sync";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = false; # overrides any folders added or deleted through the WebUI
      settings = {
        gui.theme = "black";
        devices = {
          "kei" = {
            id = "WZFILN5-NZ4YJGE-NEWUFQR-EPQTDYM-ZRG6WO4-FC4EB4M-XE5DPEC-XJV5NQ3";
            autoAcceptFolders = true;
          };
          "suzaku" = {
            id = "RWDBRPT-5UQFQH6-X5TSCEC-R2EENOZ-2OIO57D-AJZDJTD-ALPDILE-ME2CVQF";
            autoAcceptFolders = true;
          };
          "seiryu" = {
            id = "VHONWML-AZNC73N-KBJ62KW-NEM27CZ-ZRDTB34-TUHPCYS-7X4B2HF-4L7NTQA";
            autoAcceptFolders = true;
          };
          "genbu" = {
            id = "3H6X5PB-BXBVXDM-FEI4VNL-EXEPUNM-6VW6TWO-273GWRH-4QA3EYS-OOETRQN";
            autoAcceptFolders = false;
          };
          "byakko" = {
            id = "YJDWZRL-XHRLD6X-Z5U5YG4-BQE44GI-PMU4RD4-LPNYCZF-4SUY5RY-2VMFQQK";
            autoAcceptFolders = true;
          };
        };
      };
      #      gui = {
      #        user = username;
      #        password = "";
      #      };
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

    # Thunar functionalities
    # Mount, trash, and other functionalities
    gvfs.enable = true;
    # Thumbnail support for images
    tumbler.enable = true;

    # Suspend when power key is pressed
    logind.settings.Login.HandlePowerKey = lib.mkDefault "ignore";

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
    settings.Manager = {
      DefaultTimeoutStopSec = "15";
      DefaultTimeoutAbortSec = "5s";
    };
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
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = ["/home/${username}/.ssh/id_ed25519"];
      keyFile = "/home/${username}/sops/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = true;
    };
  };

  environment.etc = {
    "machine-id".source = "/nix/persist/etc/machine-id";
    "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
  };
}
