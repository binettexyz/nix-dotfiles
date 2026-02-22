{ inputs, ... }:
{

  flake.nixosModules.jovian =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.jovian.nixosModules.jovian
      ];
      jovian.steam = {
        enable = true;
        # Boot straight into gamemode.
        autoStart = true;
        user = config.meta.username;
        # Gamescope's desktop mode. Need to force disable "services.xserver.displayManager".
        desktopSession = "plasma";
      };

      jovian.devices.steamdeck =
        if (lib.elem "steamdeck" config.modules.device.tags) then
          {
            enable = true;
            autoUpdate = true; # Auto update firmware/bios. Can be manually be done if disabled with the tools in systemPackages bellow.
            enableGyroDsuService = true;
            enableVendorDrivers = true;
          }
        else
          {
            enable = false;
            autoUpdate = false;
          };

      jovian.decky-loader = {
        # Requires enabling CEF remote debugging in dev mode settings.
        enable = true;
        # Directory to store plugins as.
        stateDir = "/var/lib/decky-loader"; # Default
        user = config.meta.username;
      };

      # Create Steam CEF debugging file if it doesn't exist for Decky Loader.
      systemd.services.steam-cef-debug = {
        description = "Create Steam CEF debugging file";
        serviceConfig = {
          Type = "oneshot";
          User = config.jovian.steam.user;
          ExecStart = "/bin/sh -c 'mkdir -p ~/.steam/steam && [ ! -f ~/.steam/steam/.cef-enable-remote-debugging ] && touch ~/.steam/steam/.cef-enable-remote-debugging || true'";
        };
        wantedBy = [ "multi-user.target" ];
      };

      networking.networkmanager.enable = true;

      # Steamdeck firmwate updater
      environment.systemPackages = [ pkgs.steamdeck-firmware ];

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "steam-jupiter-unwrapped"
          "steamdeck-hw-theme"
        ];
    };
}
