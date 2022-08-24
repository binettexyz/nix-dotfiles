{ pkgs, ... }: {

  home-manager.users.binette.programs.qutebrowser = {
    enable = true;
    package = pkgs.unstable.qutebrowser;

    enableDefaultBindings = true;
    keyBindings = {
      normal = {
#        ",v" = "spawn --userscript view_in_mpv";
#        ",V" = "hint links userscript view_in_mpv";
        ",v" = "hint links spawn mpv {hint-url}";
        ",V" = "spawn mpv {hint-url}";
        ",y" = "hint links spawn st -e yt-dlp {hint-url}";


        "<Ctrl-l>" = "set-cmd-text -s :open";

#        "zl" = "spawn --userscript qute-pass";
#        "zul" = "spawn --userscript qute-pass --username-only";
#        "zpl" = "spawn --userscript qute-pass --password-only";
      };
    };

    aliases = {
      "q" = "quit";
      "w" = "session-save";
      "wq" = "quit--save";
    };

    extraConfig = (builtins.readFile ./themes/gruvbox.py);

    quickmarks = {
    };

    searchEngines = {
    };

    loadAutoconfig = false;
    settings = {
      auto_save.session = true;
      confirm_quit = [ "downloads" ];
      content = {
        autoplay = false;
        blocking = {
          enabled = true;
          method = "both"; # Brave’s ABP-style adblocker & host 
          whitelist = [];
          hosts.lists = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://www.github.developerdan.com/hosts/lists/facebook-extended.txt"
            "https://malware-filter.gitlab.io/malware-filter/urlhaus-filter-hosts.txt"
          ];
          adblock.lists = [
#            "https://easylist.to/easylist/easylist.txt"
#            "https://easylist.to/easylist/easyprivacy.txt"
#            "https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2020.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2021.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2022.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/legacy.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/lan-block.txt"
#            "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-unbreak.txt"
#            "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-social.txt"
#            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt"
#            "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
#            "https://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext&_=223428"

            "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
            "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
            "https://fanboy.co.nz/r/fanboy-ultimate.txt"
            "https://fanboy.co.nz/fanboy-antifacebook.txt"
            "https://fanboy.co.nz/fanboy-annoyance.txt"
            "https://fanboy.co.nz/fanboy-cookiemonster.txt"
            "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            "https://github.com/DandelionSprout/adfilt/raw/master/AnnoyancesList"
            "https://github.com/DandelionSprout/adfilt/raw/master/SocialShareList.txt"
            "https://github.com/DandelionSprout/adfilt/raw/master/ExtremelyCondensedList.txt"
          ];
        };
        fullscreen.window = true;
        headers.accept_language = "en-GB,en-US;q=0.9,en;q=0.8";
        notifications.enabled = false;
      };
      colors.webpage.preferred_color_scheme = "dark";
      downloads = {
        location.directory = "~/downloads";
        location.suggestion = "path";
        position = "bottom";
        remove_finished = 5;
      };
      editor.command = [ "st" "-e" "nvim" "{}" ];
      scrolling = {
        bar = "never";
        smooth = true;
      };
      session.default_name = "default";
      statusbar = {
        show = "in-mode";
        widgets = [ "history" "url" "progress" "scroll" "tabs" ];
      };
      tabs = {
        show = "multiple";
        position = "top";
        width = 15;
        indicator.width = 3;
        new_position.unrelated = "next";
        last_close = "default-page";
        select_on_remove = "last-used";
      };

      fonts = {
        contextmenu = "Noto Sans";
        default_family = [ "JetBrainsMono Nerd Font" ];
        default_size = "14px";
        web.family = {
          sans_serif = "Noto Sans";
          serif = "Noto Serif";
        };
      };
    };
  };
}
