{
  pkgs,
  config,
  lib,
  ...
}:
with lib;

let
  browser = "${pkgs.firefox}/bin/librewolf";
  mpv = "${pkgs.mpv}/bin/mpv";
  cfg = config.modules.hm.newsboat;
in
{

  options.modules.hm.newsboat.enable = mkOption {
    description = "Enable newsboat";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.newsboat = {
      enable = true;

      autoReload = true;
      browser = "${browser}";
      maxItems = 0; # 0 = infinite
      reloadTime = 5; # time in minutes

      extraConfig = lib.strings.concatStringsSep "\n" [
        # Keybindings
        ''
          bind-key j down
          bind-key k up
          bind-key j next articlelist
          bind-key k prev articlelist
          bind-key J next-feed articlelist
          bind-key K prev-feed articlelist
          bind-key G end
          bind-key g home
          bind-key d pagedown
          bind-key u pageup
          bind-key l open
          bind-key h quit
          bind-key a toggle-article-read
          bind-key n next-unread
          bind-key N prev-unread
          bind-key D pb-download
          bind-key U show-urls
          bind-key x pb-delete
        ''
        # Gruvbox theme
        ''
          #color background         color3    color0 
          color listnormal         color7    default
          color listfocus          color7    color237  standout
          color listnormal_unread  color2    default
          color listfocus_unread   color7    color237  standout
          color info               color4    color0
          color article            color223  color0

          #highlight all "---.*---" color7 default
          #highlight feedlist ".*(0/0))" black
          highlight article "(^Feed:.*|^Author:.*)" color6 default bold
          highlight article "(^Link:.*|^Date:.*)" default default
          highlight article "https?://[^ ]+" color2 default
          highlight article "^(Title):.*$" color166 default
          highlight article "\\[[0-9][0-9]*\\]" color13 default bold
          highlight article "\\[image\\ [0-9]+\\]" color2 default bold
          highlight article "\\[embedded flash: [0-9][0-9]*\\]" color2 default bold
          highlight article ":.*\\(link\\)$" color2 default
          highlight article ":.*\\(image\\)$" color9 default
          highlight article ":.*\\(embedded flash\\)$" color13 default
        ''
        # Macros
        ''
          macro , open-in-browser
          macro v set browser "${mpv} %u" ; open-in-browser ; set browser "${browser} %u"
          macro t set browser "qndl" ; open-in-browser ; set browser "${browser} %u"
          macro a set browser "tsp youtube-dl --add-metadata -xic -f bestaudio/best" ; open-in-browser ; set browser "${browser} %u"
          macro v set browser "setsid -f mpv" ; open-in-browser ; set browser "${browser} %u"
          macro w set browser "lynx" ; open-in-browser ; set browser "${browser} %u"
          macro d set browser "dmenuhandler" ; open-in-browser ; set browser "${browser} %u"
          macro c set browser "echo %u | xclip -r -sel c" ; open-in-browser ; set browser "${browser} %u"
          macro C set browser "youtube-viewer --comments=%u" ; open-in-browser ; set browser "${browser} %u"
          macro p set browser "peertubetorrent %u 480" ; open-in-browser ; set browser "${browser} %u"
          macro P set browser "peertubetorrent %u 1080" ; open-in-browser ; set browser "${browser} %u"
        ''
      ];

      urls = [
        { url = "--------REDDIT----------"; }
        {
          title = "r/Switch";
          url = "https://www.reddit.com/r/Switch.rss";
        }
        { url = "--------YOUTUBE---------"; }
        {
          title = "Lukesmith";
          url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhA";
        }
        { url = "-------NEWSFEEDS--------"; }
        { url = "https://lukesmith.xyz/rss.xml"; }
        { url = "https://www.archlinux.org/feeds/news/"; }
        { url = "https://www.phoronix.com/rss.php"; }
        { url = "https://xeiaso.net/blog.rss"; }
        { url = "https://www.gamingonlinux.com/article_rss.php"; }
        { url = "https://nixos.org/blog/announcements-rss.xml"; }
        { url = "-------GIT-COMMITS------"; }
        {
          title = "NixOS Home-Manager";
          url = "https://github.com/nix-community/home-manager/commits.atom";
        }
      ];
    };
  };

}
