{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.librewolf;
in
{
  options.modules.programs.librewolf = {
    enable = mkOption {
      description = "Enable librewolf browser";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.librewolf = {
      enable = true;
      settings = {
        "browser.uidensity" = 1; # compact mode
        "browser.startup.page" = 3; # restore session
        "browser.warnOnQuitShortcut" = false;
        "identity.fxaccounts.enabled" = true; # Firefox Sync
        "webgl.disabled" = true; # use Canvas Blocker if "true"
        "media.peerconnection.ice.no_host" = false;
        "browser.sessionstore.resume_from_crash" = false;
        "security.OCSP.require" = false;
        "network.dns.disableIPv6" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.cookies" = false;
      };
    };

    home.packages = with pkgs; [ ff2mpv ];

  };

}
