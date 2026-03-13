{ inputs, ... }:
{
  flake.nixosModules.defaultPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "teamspeak3"
          "teamspeak6-client"
          "teamspeak-server"
        ];

      nixpkgs.config.permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    };
}
