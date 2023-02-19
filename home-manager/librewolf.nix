{ inputs, pkgs, config, lib, ... }:
with lib;

{

  programs.librewolf = {
    enable = true;
    settings = {
#      "browser.quitShortcut.disabled" = true;
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

}
