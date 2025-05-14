{
  pkgs,
  config,
  lib,
  ...
}:
with lib;

{

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "seiryu" = {
        user = "${config.home.username}";
        hostname = "100.78.201.86";
        port = 704;
      };
      "kageyami" = {
        hostname = "100.69.22.72";
        port = 704;
      };
      "gyorai" = {
        hostname = "100.102.251.119";
        user = "${config.home.username}";
        port = 704;
      };
      "kokoro" = {
        hostname = "100.95.71.37";
        user = "${config.home.username}";
        port = 704;
      };
    };
  };

}
