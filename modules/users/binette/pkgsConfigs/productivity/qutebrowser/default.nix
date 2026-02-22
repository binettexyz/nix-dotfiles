{
  flake.modules.homeManager.binetteQutebrowser =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.modules.hm.browser.qutebrowser;
      cfgTheme = config.modules.hm.theme.colorScheme;
    in
    {
      options.modules.hm.browser.qutebrowser.enable = lib.mkOption {
        description = "Enable qutebrowser";
        default = false;
      };

      config = lib.mkIf cfg.enable {
        programs.qutebrowser = {
          enable = true;

          enableDefaultBindings = true;
          keyBindings = {
            normal = {
              ",v" = "hint links spawn mpv {hint-url}";
              ",V" = "spawn mpv {hint-url}";
              ",y" = "hint links spawn st -e yt-dlp {hint-url}";
              "<Ctrl-l>" = "set-cmd-text -s :open";
              #          "zl" = "spawn --userscript qute-pass";
              #          "zul" = "spawn --userscript qute-pass --username-only";
              #          "zpl" = "spawn --userscript qute-pass --password-only";
            };
          };

          aliases = {
            "q" = "quit";
            "w" = "session-save";
            "wq" = "quit--save";
          };

          extraConfig =
            if cfgTheme == "catppucin" then
              (builtins.readFile ./themes/catppuccin.py)
            else if cfgTheme == "jmbi" then
              (builtins.readFile ./themes/jmbi.py)
            else if cfgTheme == "gruvbox" then
              (builtins.readFile ./themes/gruvbox-material.py)
            else
              "";

          searchEngines = {
            yt = "https://www.youtube.com/results?search_query={}";
            am = "https://www.amazon.com/s?k={}";
          };

          quickmarks = {
            mal = "https://myanimelist.net/profile/Binette";
            jack = "http://rpi4:9117/";
            sonn = "http://rpi4:8989/";
            trans = "http://rpi4:9091/";
            lid = "http://rpi4:8686/";
            rad = "http://rpi4:7878/";
            git = "https://github.com/binettexyz";
            yt = "https://www.youtube.com/?hl=fr&gl=CA";
            red = "https://www.reddit.com/";
            disc = "https://discord.com/login";
            wf = "https://www.wallpaperflare.com/";
            wa = "https://wallhaven.cc/";
            translate = "https://www.deepl.com/translator";
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
                whitelist = [ ];
                hosts.lists = [
                  "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                  "https://malware-filter.gitlab.io/malware-filter/urlhaus-filter-hosts.txt"
                ];
                adblock.lists = [
                  "https://raw.githubusercontent.com/easylist/easylist/refs/heads/gh-pages/easylist.txt"
                  "https://raw.githubusercontent.com/easylist/easylist/refs/heads/gh-pages/easyprivacy.txt"
                  "https://raw.githubusercontent.com/easylist/easylist/refs/heads/gh-pages/fanboy-annoyance.txt"
                  "https://raw.githubusercontent.com/easylist/easylist/refs/heads/gh-pages/fanboy-newsletter.txt"
                  "https://raw.githubusercontent.com/easylist/easylist/refs/heads/gh-pages/fanboy-social.txt"
                  "https://raw.githubusercontent.com/easylist/easylist/refs/heads/gh-pages/fanboy-sounds.txt"
                ];
              };
              fullscreen.window = true;
              headers.accept_language = "en-US,en;q=0.5";
              notifications.enabled = false;
            };
            colors.webpage.preferred_color_scheme = "dark";
            downloads = {
              location.directory = "~/downloads";
              location.suggestion = "path";
              position = "bottom";
              remove_finished = 5;
            };
            #        editor.command = [
            #          "st"
            #          "-e"
            #          "nvim"
            #          "{}"
            #        ];
            scrolling = {
              bar = "never";
              smooth = true;
            };
            session.default_name = "default";
            statusbar = {
              show = "in-mode";
              widgets = [
                "history"
                "url"
                "progress"
                "scroll"
                "tabs"
              ];
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
              default_family = "sans-serif";
              default_size = "12pt";
            };
          };
          greasemonkey = [
            (pkgs.writeText "yt-addSkip.js" ''
              // ==UserScript==
              // @name         Auto Skip YouTube Ads
              // @version      1.0.1
              // @description  Speed up and skip YouTube ads automatically
              // @author       jso8910
              // @match        *://*.youtube.com/*
              // @exclude      *://*.youtube.com/subscribe_embed?*
              // ==/UserScript==
              let main = new MutationObserver(() => {
                  let ad = [...document.querySelectorAll('.ad-showing')][0];
                  if (ad) {
                      let btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button')
                      if (btn) {
                          btn.click()
                      }
                  }
              })

              main.observe(document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button'), {attributes: true, characterData: true, childList: true})
            '')
          ];
        };
      };
    };
}
