{ pkgs, system, config, lib, inputs, modulesPath, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system/default.nix
    ../../modules/system/desktop/transmission
  ];

  ## Custom modules ##
  modules = {
    bootloader = "grub";
    windowManager = "dwm";
    transmission.enable = false;
    services = {
      greenclip.enable = true;
      tty-login-prompt.enable = true;
    };
    profiles = {
      gaming.enable = true;
      core = {
        enable = true;
        bluetooth.enable = true;
        wifi.enable = true;
        print.enable = true;
        ssd.enable = true;
        virtmanager.enable = false;
        impermanence.enable = true;
      };
    };
  };

  ## hardware ##

    # GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      modesetting.enable = true;
        # Enable experimental NVIDIA power management via systemd
      powerManagement.enable = true;
    };
    opengl.extraPackages = with pkgs; [ vaapiVdpau ];
  };

    # CPU
  nix.settings.max-jobs = 16; # ryzen 7 5800x
  hardware.cpu.amd.updateMicrocode = true;

  ## Networking ##
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.enp34s0.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
#    wireguard.interfaces.wg0 = {
#      ips = [ "10.100.0.2/24" ];
#      listenPort = 51820;
#      privateKeyFile = "/nix/persist/srv/private/wireguard/private";
#      postSetup = ''
#        ip route add 10.0.0.103 via 10.0.0.1 dev wlo1
#      '';
#
#      # This undoes the above command
#      postShutdown = ''
#        ip route del 10.0.0.103 via 10.0.0.1 dev wlo1
#      '';
#      peers = [
#        {
#          publicKey = "Z1MGweKDq5jSSp+rzoRzw+5hH+Br89jRIg8ijVDdFz0=";
#          allowedIPs = [ "0.0.0.0/0" ];
#          endpoint = "10.0.0.103:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
#            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
#          persistentKeepalive = 25;
#        }
#      ];
#    };
  };

  ## Kernel modules/packages ##
  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" "nvidia" ];
#    kernelPackages =  pkgs.linuxPackages_zen;
    kernelPackages =  pkgs.linuxPackages_xanmod;
    kernelParams = [ /*"mitigations=off"*/ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  ## FileSystem ##
  fileSystems = {
    "/nix/persist/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/mounts/nas" = {
      device = "100.71.254.90:/media";
      fsType = "nfs";
        # don't freeze system if mount point not available on boot
      options = [ "x-systemd.automount" "noauto" ];
    };
  };
  swapDevices = [ ];
#  swapDevices = [ { device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; } ];

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/mounts"
      ];
    };
    "/nix/persist/home/binette/.local/share" = {
      hideMounts = true;
      directories = [
        "/opt"
      ];
    };
  };

  ## Performance stuff ##
  powerManagement.cpuFreqGovernor = "conservative";
  programs.gamemode.enable = true;

  ## Screen resolution ##
#  services.xserver = {
#    xrandrHeads = [{
#      output = "DP-2";
#      primary = true;
#      monitorConfig = ''
#          # 2560x1440 164.90 Hz (CVT) hsync: 261.86 kHz; pclk: 938.50 MHz
#        Modeline "2560x1440_165.00"  938.50  2560 2792 3072 3584  1440 1443 1448 1588 -hsync +vsync
#        Option "PreferredMode" "2560x1440_165.00"
#        Option "Position" "0 0"
#      '';
#    }];
#  };

  nixpkgs.config.allowUnfree = true;

}
