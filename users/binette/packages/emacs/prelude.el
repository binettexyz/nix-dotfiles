;; Silence compiler warnings as they can be pretty disruptive
(if (boundp 'comp-deferred-compilation)
    (setq comp-deferred-compilation nil)
    (setq native-comp-deferred-compilation nil))
;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

;; By default in Emacs, we don’t have ability to select text
;; and then start typing and our new text replaces the selection.  Let’s fix that!
(delete-selection-mode t)

;; keybinding for dired-mode
;(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
;               "d d" '(dired :which-key "Open dired")
;               "d j" '(dired-jump :which-key "Dired jump to current")
;               "d p" '(peep-dired :which-key "Peep-dired"))

(with-eval-after-load 'dired
  ;;(define-key dired-mode-map (kbd "M-p") 'peep-dired)
  (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
  (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file))

(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))


;; Buffers and bookmarks
;(nvmap :prefix "SPC"
;       "b b"   '(ibuffer :which-key "Ibuffer")
;       "b c"   '(clone-indirect-buffer-other-window :which-key "Clone indirect buffer other window")
;       "b k"   '(kill-current-buffer :which-key "Kill current buffer")
;       "b n"   '(next-buffer :which-key "Next buffer")
;       "b p"   '(previous-buffer :which-key "Previous buffer")
;       "b B"   '(ibuffer-list-buffers :which-key "Ibuffer list buffers")
;       "b K"   '(kill-buffer :which-key "Kill buffer"))

;;; prelude.el ends here.

