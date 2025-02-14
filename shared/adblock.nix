{ lib, pkgs, ... }:

let
  baseUrl = "https://raw.githubusercontent.com/StevenBlack/hosts";
  commit = "37cd96c0fe95ad3357b9dffe9e612f7e539ece35";
  hostsFile = pkgs.fetchurl {
    url = "${baseUrl}/${commit}/alternates/fakenews-gambling/hosts";
    sha256 = "sha256-sMIrZtUaflOGFtSL3Nr9jSfnGPA/goE0RAZ8jlNVvAs=";
  };
  hostsContent = lib.readFile hostsFile;
in {
  networking.extraHosts = hostsContent + ''
  '';
}
