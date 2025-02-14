{ lib, pkgs, ... }:

let
  baseUrl = "https://raw.githubusercontent.com/StevenBlack/hosts";
  commit = "master";
  hostsFile = pkgs.fetchurl {
    url = "${baseUrl}/${commit}/alternates/fakenews-gambling-porn-social/hosts";
    sha256 = "sha256-KXZg59t3fCHtqExy4nWKQCLZUE+LvStYYZB+BKulnh0=";
  };
  hostsContent = lib.readFile hostsFile;
in {
  networking.extraHosts = hostsContent + ''
  '';
}
