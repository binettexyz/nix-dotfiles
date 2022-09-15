{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.core;
in
{
  imports = [
    (inputs.impermanence + "/nixos.nix")
    ./packages.nix
    ./tty-login.nix
  ];

  options.modules.profiles.core = {
    enable = mkOption {
      description = "Enable core options";
      type = types.bool;
      default = true;
    };

    sound.enable = mkOption {
      description = "Enable sound";
      type = types.bool;
      default = true;
    };

    bluetooth.enable = mkOption {
      description = "Enable bluetooth";
      type = types.bool;
      default = false;
    };

    wifi.enable = mkOption {
      description = "Enable wifi";
      type = types.bool;
      default = false;
    };

    print.enable = mkOption {
      description = "Enable print";
      type = types.bool;
      default = false;
    };

    ssd.enable = mkOption {
      description = "Enable enable fstrim";
      type = types.bool;
      default = false;
    };

    virtmanager.enable = mkOption {
      description = "Enable enable fstrim";
      type = types.bool;
      default = false;
    };


    impermanence.enable = mkOption {
      description = "Enable impermanence";
      type = types.bool;
      default = true;
    };

  };

  config = mkIf (cfg.enable) (mkMerge [
    ({
        # Set environment variables
      environment.variables = {
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        EDITOR = "nvim";
        TERMINAL = "st";
        BROWSER = "librewolf";
      };

        # Nix settings, auto cleanup and enable flakes
      nix = {
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 4d";
        };
        extraOptions = ''
          experimental-features = nix-command flakes
          keep-outputs = true
          keep-derivations = true

        '';
        settings = {
          auto-optimise-store = true;
          allowed-users = [ "binette" ];
        };
      };

        # Get rid of defaults packages
      environment.defaultPackages = [ ];

          # Fonts
      fonts = {
        fontDir.enable = true;
        fontconfig = {
          enable = true;
          includeUserConf = true;
          cache32Bit = true;
          defaultFonts = {
            emoji = [ "Noto Color Emoji" ];
            sansSerif = [
              "JetBrainsMono Nerd Font Mono"
            ];
            monospace = [
#              "FiraCode Nerd Font Mono"
#              "Iosevka Term"
              "FantasqueSansMono Nerd Font Mono"
#              "mononoki Nerd Font Mono"
            ];
          };
        };

        fonts = with pkgs; [
            # Emoji/Icons
          font-awesome
          noto-fonts-emoji
          material-design-icons
          material-icons
    
            # Fonts
          (nerdfonts.override {
            fonts = [
              "Iosevka"
              "FiraCode"
              "JetBrainsMono"
              "Mononoki"
              "FantasqueSansMono"
            ];
          })
            # LaTeX
          lmodern
        ];
      };
      environment.systemPackages = with pkgs; [ faba-mono-icons ];

      programs.ssh = {
        extraConfig = ''
          Host *
            IdentitiesOnly yes
            AddKeysToAgent yes
            IdentityFile ~/.ssh/id_ed25519
        '';
      };

      services.openssh = {
        enable = true;
        startWhenNeeded = true;
#        passwordAuthentication = false;
        allowSFTP = true;
        kbdInteractiveAuthentication = false;
        forwardX11 = false;
        extraConfig = ''
          AllowTcpForwarding yes
          AllowAgentForwarding no
          AllowStreamLocalForwarding no
        '';
          #AuthenticationMethods publickey
      };

      services.tailscale.enable = true;

        # Boot settings: clean /tmp, silent boot etc.
      boot = {
          # Mount tmpfs on /tmp
        tmpOnTmpfs = lib.mkDefault true;  
        cleanTmpDir = true;

          # Silent boot
#        initrd.verbose = false;
#        consoleLogLevel = 0;
#        kernelParams = [ "quiet" "udev.log_level=3"];

        loader = {
          timeout = 1;
          };
      };

        # X servers
      services.xserver = {
        enable = true;
        layout = "us";
          # enable startx
        displayManager.startx.enable = true;
          # disable xterm
        desktopManager.xterm.enable = false;
      };

        # Locales
      time.timeZone = "Canada/Eastern";
      location = {
        provider = "manual";
        latitude = 45.30;
        longitude = -73.35;
      };
      i18n.defaultLocale = "en_US.UTF-8";
      console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
      };

        # User
      users = {
        defaultUserShell = lib.mkForce pkgs.zsh;
        mutableUsers = false;
        groups.binette.gid = 1000;
        users.binette = {
          uid = 1000;
          isNormalUser = true;
          createHome = true;
          home = "/home/binette";
          group = "binette";
          extraGroups = [ "wheel" "binette" "users" "audio" "video" "storage" "libvirtd" ];
          hashedPassword =
            "$6$89SIC2h2WeoZT651$26x4NJ1vmX9N/B54y7mc5pi2INtNO0GqQz75S37AMzDGoh/29d8gkdM1aw6i44p8zWvLQqhI0fohB3EWjL5pC/";
        };
        users.root = {
          hashedPassword =
            "$6$rxT./glTrsUdqrsW$Wzji63op8yTEBoIEcWBc26KOlFJtqx.EKpsGV1A2bQT9oB1JKtrlfdArYICc/Ape.msHcj6ObyXlmRKTWTC/J.";
        };
      };

        # Networking
      networking = {
        enableIPv6 = false;
        useDHCP = lib.mkDefault false;
        networkmanager.enable = false;
        nameservers = [ "94.140.14.14" "94.140.15.15" ];
        firewall = {
          enable = lib.mkForce true;
          allowedTCPPorts = [
            2049 # NFSv4
          ];
            # tailscale
          checkReversePath = "loose";
          trustedInterfaces = [ "tailscale0" ];
        };
      };

        # Security
      security = {
          # prevent replacing the running kernel image
        protectKernelImage = true;
        sudo.enable = false;
        doas = {
          enable = true;
          extraRules = [{ users = [ "binette" ]; noPass = true; keepEnv = true; }];
        };
      };

      boot.blacklistedKernelModules = [
          # Obscure network protocols
        "ax25"
        "netrom"
        "rose"
          # Old or rare or insufficiently audited filesystems
        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "freevxfs"
        "f2fs"
        "vivid"
        "gfs2"
        "ksmbd"
    #    "nfsv4"
    #    "nfsv3"
        "cifs"
    #    "nfs"
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "squashfs"
        "udf"
    #    "bluetooth"
        "btusb"
    #    "uvcvideo" # webcam
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "omfs"
        "uvcvideo"
        "qnx4"
        "qnx6"
        "sysv"
        "ufs"
      ];

        # Hardware
      hardware = {
          # Opengl
        opengl.enable = true;
          # Enable Font/DPI configuration optimized for HiDPI displays
        video.hidpi.enable = true;
      };

        # Needed by home-manager's impermanence
      programs.fuse.userAllowOther = true;

        # File Systems
      fileSystems = {
        "/" = { 
          device = "none";
          fsType = "tmpfs";
          options = [ "defaults" "size=2G" "mode=755" ];
        };
        "/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
        };
        "/nix" = {
          device = "/dev/disk/by-label/nix";
          fsType = "ext4";
        };
      };


      environment.etc = {
        "machine-id".source = "/nix/persist/etc/machine-id";
        "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
        "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
        "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
        "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
      };


        # don't install documentation i don't use
      documentation.enable = true; # documentation of packages
      documentation.nixos.enable = true; # nixos documentation
      documentation.man.enable = true; # manual pages and the man command
      documentation.info.enable = false; # info pages and the info command
      documentation.doc.enable = false; # documentation distributed in packages' /share/doc

      system.stateVersion = "22.05";
    })

    (mkIf cfg.sound.enable {
        # enable sound
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
          # If you want to use JACK applications, uncomment this
#        jack.enable = true;
#        lowLatency = {
#          enable = true;
#          quantum = 64;
#          rate = 48000;
#        };
      };
        # make pipewire realtime-capable
      security.rtkit.enable = true;
    })

    (mkIf cfg.bluetooth.enable {
        # Enable Bluetooth
      hardware.bluetooth.enable = true;
      services.blueman.enable = lib.mkIf (config.services.xserver.enable) true;
      programs.dconf.enable = lib.mkIf (config.services.xserver.enable) true;
    })

    (mkIf cfg.wifi.enable {
        # Enable WIFI
      networking.wireless = {
        enable = true;
        userControlled.enable = true;
        networks = {
            # home
          "Hal" = {
            priority = 0;
            auth = ''
	            psk=af8dca01536bdf1b08911c118df5971defa78264c21a376fbc41e92f628b6a26
            '';
          };
            # home (Extender)
          "Hal_EXT" = {
            priority = 0;
            auth = ''
	            psk=723f7b995aae04f46f4cebfab286b31c8db116015f0a26fe20bc4695d4c01af9
              proto=RSN
              pairwise=CCMP
              auth_alg=OPEN
            '';
          };
        };
      };
    })

    (mkIf cfg.print.enable {
        # Enable Printer
      services.printing.enable = true;
    })

    (mkIf cfg.ssd.enable {
      # swap ram when % bellow is reach (1-100)
    boot.kernel.sysctl = { "vm.swappiness" = 1; };
    services.fstrim.enable = true; # ssd trimming
    })

    (mkIf cfg.virtmanager.enable {
      virtualisation.libvirtd.enable = true;
      programs.dconf.enable = true;

      users.users.binette.extraGroups = [ "libvirtd" ];

      environment.systemPackages = with pkgs; [ virt-manager ];
    })

    (mkIf cfg.impermanence.enable {
        # Impermanence
      environment.persistence."/nix/persist" = {
        hideMounts = true;
        directories = [
          "/etc/nixos"
          "/var/lib"
          "/var/log"
          "/root"
          "/srv"
        ];
      };
    })
  ]);

}
