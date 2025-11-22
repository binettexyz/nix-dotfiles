{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.hm.browser.librewolf;
in
{
  options.modules.hm.browser.librewolf.enable = lib.mkOption {
    description = "Enable librewolf";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "browser.quitShortcut.disabled" = true;
        "browser.uidensity" = 0; # compact mode
        "browser.startup.page" = 3; # restore session
        "browser.warnOnQuitShortcut" = false;
        "identity.fxaccounts.enabled" = true; # Firefox Sync
        "webgl.disabled" = true; # use Canvas Blocker if "true"
        "media.peerconnection.ice.no_host" = false;
        "browser.sessionstore.resume_from_crash" = false;
        "security.OCSP.require" = false;
        "network.dns.disableIPv6" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = false;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.cookies" = false;
      };
    };

    home.packages = lib.mkIf cfg.enable [ pkgs.ff2mpv ];
  };
}
