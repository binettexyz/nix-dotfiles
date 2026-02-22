{ inputs, ... }:
{
  flake.nixosModules.defaultPackages =
    { config, pkgs, ... }:
    {
      imports = with inputs.self.nixosModules; [ thunar ];
      environment.defaultPackages = [
        # Overlay Script
        pkgs.nix-rebuild
        pkgs.nix-deploy
        pkgs.screenshot
        pkgs.sysact
        pkgs.clipboard
        pkgs.wofirun

        pkgs.bat
        pkgs.cron
        pkgs.curl
        pkgs.eza
        pkgs.fzf
        pkgs.gcc
        pkgs.gnused
        pkgs.capitaine-cursors-themed
        pkgs.rsync
        pkgs.expect
        pkgs.nix-output-monitor
        pkgs.wget
      ]
      ++ (
        if (config.modules.device.type == "laptop") then
          [
            pkgs.powertop
            pkgs.acpid
            pkgs.brightnessctl
          ]
        else
          [ ]
      );

      programs = {
        nano.enable = false;
        fish.enable = true;
        git = {
          enable = true;
          config.init.defaultBranch = "main";
        };
        nh = {
          enable = true;
          flake = "/etc/nixos";
        };
      };
    };
}
