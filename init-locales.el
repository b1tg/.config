;;; init-locales.el --- Configure default locale -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defun sanityinc/locale-var-encoding (v)
  "Return the encoding portion of the locale string V, or nil if missing."
  (when v
    (save-match-data
      (let ((case-fold-search t))
        (when (string-match "\\.\\([^.]*\\)\\'" v)
          (intern (downcase (match-string 1 v))))))))
                                        ;(setq default-process-coding-system '(utf-8-dos . gbk-dos))
                                        ;(set-language-environment 'Chinese-GBK)
                                        ;(prefer-coding-system 'utf-8-unix)

(set-default-coding-systems 'utf-8)
;; (when (eq system-type 'windows-nt)
;;   (set-next-selection-coding-system 'utf-16-le)
;;   (set-selection-coding-system 'utf-16-le)
;;   (set-clipboard-coding-system 'utf-16-le))
;; (dolist (varname '("LC_ALL" "LANG" "LC_CTYPE"))
;;   (let ((encoding (sanityinc/locale-var-encoding (getenv varname))))
;;     (unless (memq encoding '(nil utf8 utf-8))
;;       (message "Warning: non-UTF8 encoding in environment variable %s may cause interop problems with this Emacs configuration." varname))))

;; (when (fboundp 'set-charset-priority)
;;   (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
;; (setq locale-coding-system 'utf-8)
;; (unless (eq system-type 'windows-nt)
;;   (set-selection-coding-system 'utf-8))

;; (prefer-coding-system 'utf-8-unix)
;; (set-default 'process-coding-system-alist
;;              '(("[pP][lL][iI][nN][kK]" gbk-dos . gbk-dos)
;;                ("[cC][mM][dD][pP][rR][oO][xX][yY]" gbk-dos . gbk-dos)
;;                ("[gG][sS]" gbk-dos . gbk-dos)))
;;(prefer-coding-system 'gbk-dos)


(custom-set-variables
 '(epg-gpg-home-directory "~/AppData/Roaming/gnupg")
 '(epg-gpg-program "C:/Program Files (x86)/GnuPG/bin/gpg.exe")
 '(epg-gpgconf-program "c:/Program Files (x86)/GnuPG/bin/gpgconf.exe")
 )
(add-to-list 'org-capture-templates
             '("j" "Journal" entry (file+datetree "~/Dropbox/org/journal.org")
               "* %U - %^{heading}\n  %?"))
;; (setq face-font-rescale-alist '(("Microsoft Yahei" . 1.2) ("WenQuanYi Zen Hei" . 1.2)))

;; (set-language-environment 'chinese-gbk)
;; (prefer-coding-system 'utf-8-auto)

;; (add-to-list 'after-make-frame-functions
;;              (lambda (new-frame)
;;                (select-frame new-frame)
;;                ;; English Font
;;                (set-face-attribute 'default nil :font "Fira Mono 12")
;;                ;; Chinese Font
;;                (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;                  (set-fontset-font (frame-parameter nil 'font)
;;                                    charset (font-spec :family "Noto Sans CJK SC" :size 16)))))

(set-face-attribute 'default nil :font "DejaVu Sans Mono 12")
;; Setting Chinese Font
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
                    charset
                    (font-spec :family "Microsoft Yahei" :size 18))
  (setq face-font-rescale-alist '(("Microsoft Yahei" . 1.4))))

(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)




;;This behavior is not encountered on all platforms. For those platforms that pose problem, I would recommend to use this setting

(setq scroll-conservatively 0)


(setq fill-column 100)

;;(require 'init-translate)



;; refer https://stackoverflow.com/questions/17435995/paste-an-image-on-clipboard-to-emacs-org-mode-file-without-saving-it
;; file api https://www.gnu.org/software/emacs/manual/html_node/elisp/File-Name-Components.html
;; elisp https://learnxinyminutes.com/docs/elisp/
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
   same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq rawname (file-name-base (buffer-file-name)))

  (setq filename
        (concat "./" rawname "/" (format-time-string "%Y%m%d_%H%M%S_") ".png" ))

  ;; (setq filename
  ;;       (concat
  ;;        (make-temp-name
  ;;         (concat (buffer-file-name)
  ;;                 "/"
  ;;                 (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))

  ;;(shell-command "snippingtool /clip")
  (shell-command (concat "powershell -command \"Add-Type -AssemblyName System.Windows.Forms;if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {$image = [System.Windows.Forms.Clipboard]::GetImage();[System.Drawing.Bitmap]$image.Save('" filename "',[System.Drawing.Imaging.ImageFormat]::Png); Write-Output 'clipboard content saved as file'} else {Write-Output 'clipboard does not contain image data'}\""))
  (insert (concat "[[" filename "]]"))
  ;;(org-display-inline-images)
  )



;; https://www.reddit.com/r/emacs/comments/7gex1q/emacs_64bit_for_windows_with_imagemagick_7/
(use-package smooth-scrolling
  :ensure t
  :config (setq smooth-scroll-margin 2)
  :init (smooth-scrolling-mode 1))
;;https://www.emacswiki.org/emacs/SmoothScrolling
(setq mouse-wheel-scroll-amount '(3 ((shift) .3) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)


;; (use-package evil
;;   :ensure t
;;   :config (
;;            (evil-mode 1))

;;   )


(require 'evil)
                                        ;http://maskray.me/blog/2015-09-18-conversion-to-emacs
                                        ;(evil-mode 1)
                                        ;(setcdr evil-insert-state-map nil)
                                        ;(define-key evil-insert-state-map (read-kbd-macro evil-toggle-key) 'evil-normal-state)
                                        ;(define-key evil-insert-state-map [escape] 'evil-normal-state)
;; https://emacs.stackexchange.com/questions/7742/what-is-the-easiest-way-to-open-the-folder-containing-the-current-file-by-the-de
(defun lc/open-in-dir ()
  "Open the current file's directory however the OS would."
  (interactive)
  (if default-directory
      (browse-url-of-file (expand-file-name default-directory))
    (error "No `default-directory' to open")))




;;(global-set-key (kbd "M-c") 'clipboard-kill-ring-save)
;;(global-set-key (kbd "M-v") 'clipboard-yank)


(setq org-agenda-files (list "~/Dropbox/org/cal.org"))
(setq org-modules '(
                    org-habit
                    ))


(eval-after-load 'org
  '(org-load-modules-maybe t))
;; https://www.reddit.com/r/orgmode/comments/7x49z9/any_way_to_get_the_habits_consistency_graph_to/
(setq org-habit-show-habits-only-for-today nil)




;; TODO: 兼容其他语言
(global-set-key (kbd "<C-down-mouse-1>") 'godef-jump)
(global-set-key (kbd "<mouse-4>") 'pop-tag-mark)
                                        ;(global-set-key (kbd "<mouse-5>") 'godef-jump)

(add-hook 'go-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c k") 'pop-tag-mark)
            (local-set-key (kbd "C-c f") 'gofmt)
            ))


;; set to 'socks to use socks
;;(setq url-gateway-method 'native)
;;(setq socks-server '("Default server" "127.0.0.1" 1080 5))

;; Configure network proxy
(setq my-proxy "127.0.0.1:1080")
(defun show-proxy ()
  "Show http/https proxy."
  (interactive)
  (if url-proxy-services
      (message "Current proxy is \"%s\"" my-proxy)
    (message "No proxy")))




;;(setq url-proxy-services `(("https" . ,my-proxy)))
(defun set-proxy ()
  "Set http/https proxy."
  (interactive)
  (setq url-proxy-services `(("http" . ,my-proxy)
                             ("https" . ,my-proxy)))
  (show-proxy))

(defun unset-proxy ()
  "Unset http/https proxy."
  (interactive)
  (setq url-proxy-services nil)
  (show-proxy))

;; not work
;; (setq ediff-diff-program "c:/MinGW/msys/1.0/bin/diff.exe")
(defun toggle-proxy ()
  "Toggle http/https proxy."
  (interactive)
  (if url-proxy-services
      (unset-proxy)
    (set-proxy)))

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
;; TODO not right binding。。
(add-hook 'nov-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c t") (quote youdao-dictionary-search-at-point-posframe))
            (face-remap-add-relative 'variable-pitch :family  "Merriweather" ;; "Segoe UI"
                                     :height 1.2)
            ))

(defun my-nov-font-setup ()
  ;;Merriweather
  (face-remap-add-relative 'variable-pitch :family  "Merriweather" ;; "Segoe UI"
                           :height 1.2))
(add-hook 'nov-mode-hook 'my-nov-font-setup)


(setq nov-text-width 80)
(setq nov-unzip-program "c:/Program Files/git/usr/bin/unzip.exe")


(setq google-translate-default-source-language "en")
(setq google-translate-default-target-language "zh-CN")




;; https://stackoverflow.com/questions/251908/how-can-i-insert-current-date-and-time-into-a-file-using-emacs
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Time-Parsing.html
(defun lc/now ()
  "Insert string for the current time."
  (interactive)
  (insert (format-time-string "[%F %a %R]")))


;;https://stackoverflow.com/questions/22960031/save-yanked-text-to-string-in-emacs
(defun lc/ty ()
  "Translate from clipboard by youdao."
  (interactive)
  (youdao-dictionary-search (current-kill 0) )
  )


(defun lc/es ()
  "Pop eshell below."
  (interactive)
  (split-window-below -10)
  (switch-window)
  (eshell)
  ;;(switch-to-buffer "cal.org")
  )
(global-set-key (kbd "<f4>") 'lc/ty)
(global-set-key (kbd "<C-M-return>") 'lc/es)

;;(global-unset-key (kbd "<f4>"))


(defun lc/i ()

  "Insert「」."
  (interactive)
  (insert "「")
  (save-excursion  (insert "」"))
  )
(defun lc/open-buffer-path ()
  "Open buffer path in explorer.exe."
  (interactive)
  (call-process-shell-command (concat  "start " default-directory)  nil nil t) ;; explorer.exe not work.
  )

;; https://stackoverflow.com/questions/13505113/how-to-open-the-native-cmd-exe-window-in-emacs
(defun lc/open-buffer-cmd ()
  "Open cmd.exe in buffer path."
  (interactive)
  (call-process-shell-command (concat  " start cmd.exe /K cd " default-directory)  nil nil t)
  )
;; https://sachachua.com/blog/2014/04/org-mode-helps-deal-ever-growing-backlog/
(setq org-deadline-warning-days 60)

;; https://github.com/sabof/org-bullets
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))


(global-set-key (kbd "<C-tab>") 'ivy-switch-buffer)
;; https://github.com/jrosdahl/iflipb not good
;; (global-set-key
;;  (if (featurep 'xemacs) (kbd "<C-iso-left-tab>") (kbd "<C-S-iso-lefttab>"))
;;  'iflipb-previous-buffer)

;; (global-set-key (kbd "M-h") 'iflipb-next-buffer)
;; (global-set-key (kbd "M-H") 'iflipb-previous-buffer)



(setq org-pomodoro-length 30)

(setq  org-pomodoro-manual-break 't)


(use-package org-roam
  :after org
  :load-path "~/.emacs.d/elisp/org-roam/"
  :hook
  ((org-mode . org-roam-mode)
   (after-init . org-roam--build-cache-async) ;; optional!
   )
  :custom
  (org-roam-directory "~/Dropbox/org/roam/")
  :bind
  ("C-c n l" . org-roam)
  ("C-c n t" . org-roam-today)
  ("C-c n f" . org-roam-find-file)
  ("C-c n i" . org-roam-insert)
  ("C-c n g" . org-roam-show-graph))


(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Dropbox/org/roam/"))
(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/Dropbox/org/roam/")
  (org-journal-date-format "%A, %d %B %Y"))








(provide 'init-locales)
;;; init-locales.el ends here
