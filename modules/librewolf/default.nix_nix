{pkgs, ...}:{

  home-manager.users.binette.programs.librewolf = {
    enable = true;
    settings = {
      "browser.uidensity" = 1; # compact mode
      "browser.startup.page" = 3; # restore session
      "browser.warnOnQuitShortcut" = false;
      "identity.fxaccounts.enabled" = true; # Firefox Sync
      "webgl.disabled" = true; # use Canvas Blocker if enabled
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
}
