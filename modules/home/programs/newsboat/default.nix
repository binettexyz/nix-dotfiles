{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.newsboat;
in
{
  options.modules.programs.newsboat = {
    enable = mkOption {
      description = "Enable newsboat package";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.newsboat = {
      enable = true;

      autoReload = true;
      browser = "\${pkgs.xdg-utils}/bin/xdg-open";
      maxItems = 0; # 0 = infinite
      reloadTime = 1; # time in minutes

      urls =[
        { tags = [ "Reddit" ]; title = "r/Switch"; url = "https://www.reddit.com/r/Switch.rss"; }
        { tags = [ "youtube" ]; title = "Lukesmith"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhA"; }
        { tags = [ "newsfeeds" ]; url = "https://lukesmith.xyz/rss.xml"; }
        { tags = [ "newsfeeds" ]; url = "https://www.archlinux.org/feeds/news/"; }
        { tags = [ "newsfeeds" ]; url = "https://www.phoronix.com/rss.php"; }
        { tags = [ "newsfeeds" ]; url = "https://xeiaso.net/blog.rss"; }
        { tags = [ "newsfeeds" ]; url = "https://www.gamingonlinux.com/article_rss.php"; }
        { tags = [ "newsfeeds" ]; url = "https://nixos.org/blog/announcements-rss.xml"; }
        { tags = [ "newsfeeds" ]; title = "NixOS Home-Manager"; url = "https://github.com/nix-community/home-manager/commits.atom"; }
      ]; 
    };
  };

}

