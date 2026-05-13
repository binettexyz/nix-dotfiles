{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  flake.nixosModules.security =
    { lib, pkgs, ... }:
    let
      baseUrl = "https://raw.githubusercontent.com/StevenBlack/hosts";
      commit = "37cd96c0fe95ad3357b9dffe9e612f7e539ece35";
      hostsFile = pkgs.fetchurl {
        url = "${baseUrl}/${commit}/alternates/fakenews-gambling/hosts";
        sha256 = "sha256-sMIrZtUaflOGFtSL3Nr9jSfnGPA/goE0RAZ8jlNVvAs=";
      };
      hostsContent = lib.readFile hostsFile;
    in
    {
      security = {
        # prevent replacing the running kernel image
        protectKernelImage = true;
        sudo.enable = false;
        doas = {
          enable = true;
          wheelNeedsPassword = false;
          extraRules = [
            {
              users = [ "binette" ];
              noPass = true;
              keepEnv = true;
            }
          ];
        };
      };

      # Add StevenBlack hosts.
      networking.extraHosts = hostsContent;

      environment.systemPackages = [ pkgs.doas-sudo-shim ];
    };
}
