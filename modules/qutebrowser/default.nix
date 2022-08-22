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
          hosts.lists = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
          adblock.lists = [
            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2020.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2021.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2022.txt"
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

    };
  };
}
