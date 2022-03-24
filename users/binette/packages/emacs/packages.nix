{ config, pkgs, lib, ... }: with pkgs; {

  programs.emacs.init.usePackage = {

    all-the-icons.enable = true;

    projectile = {
      enable = true;
      config = ''
        (projectile-global-mode 1)
      '';
    };

    dashboard = {
      enable = true;
      config = ''
        :config
        (dashboard-setup-startup-hook)
        (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))

      '';
      extraConfig = ''
        :init      ;; tweak dashboard config before loading it
        (setq dashboard-set-heading-icons t)
        (setq dashboard-set-file-icons t)
        (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
        ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
        (setq dashboard-startup-banner "~/.emacs.d/emacs-dash.png")  ;; use custom image as banner
        (setq dashboard-center-content nil) ;; set to 't' for centered content
        (setq dashboard-items '((recents . 5)
                                (agenda . 5 )
                                (bookmarks . 3)
                                (projects . 3)
                                (registers . 3)))
      '';
    };

    elfeed = {
      extraConfig = ''
        :init
        (setq elfeed-search-feed-face ":foreground #fff :weight bold"
        elfeed-feeds (quote
                       (("https://www.reddit.com/r/linux.rss" reddit linux)
                        ("https://www.reddit.com/r/commandline.rss" reddit commandline)
                        ("https://www.reddit.com/r/distrotube.rss" reddit distrotube)
                        ("https://www.reddit.com/r/emacs.rss" reddit emacs)
                        ("https://www.gamingonlinux.com/article_rss.php" gaming linux)
                        ("https://hackaday.com/blog/feed/" hackaday linux)
                        ("https://opensource.com/feed" opensource linux)
                        ("https://linux.softpedia.com/backend.xml" softpedia linux)
                        ("https://itsfoss.com/feed/" itsfoss linux)
                        ("https://www.zdnet.com/topic/linux/rss.xml" zdnet linux)
                        ("https://www.phoronix.com/rss.php" phoronix linux)
                        ("http://feeds.feedburner.com/d0od" omgubuntu linux)
                        ("https://www.computerworld.com/index.rss" computerworld linux)
                        ("https://www.networkworld.com/category/linux/index.rss" networkworld linux)
                        ("https://www.techrepublic.com/rssfeeds/topic/open-source/" techrepublic linux)
                        ("https://betanews.com/feed" betanews linux)
                        ("http://lxer.com/module/newswire/headlines.rss" lxer linux)
                        ("https://distrowatch.com/news/dwd.xml" distrowatch linux))))
      ''; 
    };

    elfeed-goodies = {
      extraConfig = ''
        :init
        (elfeed-goodies/setup)
        :config
        (setq elfeed-goodies/entry-pane-size 0.5))

        (add-hook 'elfeed-show-mode-hook 'visual-line-mode)
        (evil-define-key 'normal elfeed-show-mode-map
        (kbd "J") 'elfeed-goodies/split-show-next
        (kbd "K") 'elfeed-goodies/split-show-prev)
        (evil-define-key 'normal elfeed-search-mode-map
        (kbd "J") 'elfeed-goodies/split-show-next
        (kbd "K") 'elfeed-goodies/split-show-prev)
      '';
    };

    emojify = {
      config = ''
        :hook (after-init . global-emojify-mode)
      '';
    };

    general = {
      enable = true;
      config = ''
        (general-evil-setup t)
      '';
    };

    gcmh = {
      enable = true;
      config = ''
        (gcmh-mode 1)
      '';
      extraConfig = ''
        ;; Setting garbage collection threshold
        (setq gc-cons-threshold 402653184
              gc-cons-percentage 0.6)

        ;; Profile emacs startup
        (add-hook 'emacs-startup-hook
                  (lambda ()
                    (message "*** Emacs loaded in %s with %d garbage collections."
                             (format "%.2f seconds"
                                     (float-time
                                      (time-subtract after-init-time before-init-time)))
                             gcs-done)))

        ;; Silence compiler warnings as they can be pretty disruptive (setq comp-async-report-warnings-errors nil)
      '';
    };

    base16-theme = {
      enable = true;
      extraConfig = ":disabled";
    };

    doom-modeline = {
      enable = true;
      extraConfig = ":disabled";
    };

    evil = {
      enable = true;
      config = ''
        (evil-mode 1)
      '';
      extraConfig = ''
        :init      ;; tweak evil's configuration before loading it
        (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
        (setq evil-want-keybinding nil)
        (setq evil-vsplit-window-right t)
        (setq evil-split-window-below t)
      '';
    };

    evil-collection = {
      enable = true;
      hook = [ "(pdf-view-mode . evil-collection-pdf-setup)" ];
      extraConfig = ''
        :after evil
        :config
        (setq evil-collection-mode-list '(dashboard dired ibuffer))
        (evil-collection-init)
      '';
    };
  };

}
