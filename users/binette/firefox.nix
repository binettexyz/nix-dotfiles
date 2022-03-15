{ config, pkgs, ... }: {

  home-manager.users.binette.programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      privacy-badger
      ublock-origin
      bitwarden
      clearurls
      decentraleyes
#      redirector
      ff2mpv
      sponsorblock
      https-everywhere
      xbrowsersync
      vimium
      violentmonkey
    ];
    profiles.main = {
      id = 0;
      isDefault = true;
      settings = {
          # WebRender
        "gfx.webrender.all" = true;
          # userChrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # what's new toolbar
        "browser.messaging-system.whatsNewPanel.enabled" = false;
          # Pocket
        "extensions.pocket.enabled" = false;
          # Firefox Sync
        "identity.fxaccounts.enabled" = false;
          # recommended stuff
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSearch" = false;
          # bookmarks toolbar
        "browser.toolbars.bookmarks.visibility" = "always";
          # mobile bookmarks
        "browser.bookmarks.showMobileBookmarks" = false;
          # cookies
        "network.cookie.cookieBehavior" = "reject";
        "network.cookie.cookieBehavior.pbmode" = "reject";
          # Downloads directory
        "browser.download.dir" = "/nix/persist/home/binette/downloads";
          # disable auto update
        "app.update.auto" = false;
          # disable firefox screenshot feature
        "extensions.screenshots.disabled" = true;
          # content blocking category
        "browser.contentblocking.category" = "strict";
          # block unwanted and uncommon downloads
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
          # suggest stuff
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
          # check default browser
        "browser.shell.checkDefaultBrowser" = false;
          # formfill
        "dom.forms.autocomplete.formautofill" = true;
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
          # autoplay
        "media.autoplay.default" = 5;

#        "browser.startup.homepage" = "https://nixos.org";
        "browser.search.region" = "CA";

        "browser.warnOnQuitShortcut" = false;
        "browser.search.isUS" = false;
        "distribution.searchplugins.defaultLocale" = "en-CA";
        "general.useragent.locale" = "en-CA";
      };
    };
  };

}
