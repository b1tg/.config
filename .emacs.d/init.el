
;; (setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
;;                          ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
;;                          ("melpa-stable" . "http://mirrors.ustc.edu.cn/elpa/melpa-stable/")
;;                          ("org" . "http://mirrors.ustc.edu.cn/elpa/org/")
;; 			 ;;("org" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
;; 			 ))


(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize) ;; You might already have this line

 (unless
    (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(load "~/.emacs.d/priv.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("cabc32838ccceea97404f6fcb7ce791c6e38491fd19baa0fcfb336dcc5f6e23c" "fee4e306d9070a55dce4d8e9d92d28bd9efe92625d2ba9d4d654fc9cd8113b7f" default))
 '(package-selected-packages
   '(wakatime-mode org general go-mode deft youdao-dictionary ace-window cal-china-x elfeed meow cl-lib aggressive-indent elisp-format org-download request smex evil-leader evil-nerd-commenter git-gutter+ rustic nix-mode nov json-mode auto-highlight-symbol magit format-all ox-hugo good-scroll org-bullets base16-theme pangu-spacing git-gutter rg helm-ag counsel which-key use-package lsp-pyright evil company))
 '(tramp-default-host "127.0.0.1")
 '(tramp-default-method "plink")
 '(tramp-default-user "root")
 '(warning-suppress-log-types '(nil)))
;; use /-:: to nav to default host
;;(add-to-list 'load-path "~/.emacs.d/mannual-plugins/elfeed")
(setq elfeed-feeds
      '(
	;;"http://nullprogram.com/feed/"
	;;  "https://planet.emacslife.com/atom.xml")
	"http://googleprojectzero.blogspot.com/feeds/posts/default"
	"http://krebsonsecurity.com/feed/"
	;;	"https://rsshub.app/weibo/user/1401527553"
	"https://0dayfans.com/feed.rss"
	"https://this-week-in-rust.org/rss.xml"
	"https://www.getrevue.co/profile/happy?format=rss"
	"http://fetchrss.com/rss/625d20ed1a5d2902572c45a2625d218b37368e501775c2f2.xml"
	)
      )



(setq org-agenda-include-diary t)

(global-wakatime-mode)

;; fix python utf8 warning
(define-coding-system-alias 'UTF-8 'utf-8)
(global-display-line-numbers-mode)

(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "C-`") 'ace-window)
;; not work
;;(require 'org-download)
(defun logseq/today ()
  (interactive)
(find-file
 (concat logseq_base_dir
 "journals/"
 (format-time-string "%Y_%m_%d.md")
 )
 )
)





(defun paste_img()
  "Take a screenshot into a time stamped unique-named file in the
   same directory as the org-buffer and insert a link to this file."  
  (interactive)
  (setq logseq-p (string-match-p "logseq-try.*md" (if (buffer-file-name) (buffer-file-name) "")))
    (setq md-p (string-match-p ".*md" (if (buffer-file-name) (buffer-file-name) "")))
   (setq filename
     (concat
       (make-temp-name
        (concat
	 ;;(buffer-file-name)
	 (if logseq-p
	     "../assets"
	   "assets"
	   )
              "/"
              (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
   (print filename) 
   ;;(shell-command "snippingtool /clip")
   (shell-command (concat "powershell -command \"Add-Type -AssemblyName System.Windows.Forms;if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {$image = [System.Windows.Forms.Clipboard]::GetImage();[System.Drawing.Bitmap]$image.Save('" filename "',[System.Drawing.Imaging.ImageFormat]::Png); Write-Output 'clipboard content saved as file'} else {Write-Output 'clipboard does not contain image data'}\""))
   (if md-p
         (insert (concat "![image.png](" filename ")"))
       (insert (concat "[[file:" filename "]]"))
   
    )
     
   ;;(org-display-inline-images)
   )


;; https://www.reddit.com/r/emacs/comments/5pziif/cd_to_home_directory_of_server_when_using_eshell/
(defun eshell/cd- (new-path)
  (let* ((d default-directory)
         (s (split-string d ":"))
         (path (car (last s)))
         (l (length path))
         (host (substring d 0 (- (length d) l))))
    (eshell/cd (format "%s%s" host new-path))))
(add-to-list 'load-path "~/.emacs.d/mannual-plugins/snails") ; add snails to your load-path
(require 'cl-lib)
(require 'snails)
(setq snails-show-with-frame nil)
(require 'snails-backend-everything)
(defcustom snails-prefix-backends
  '((">" '(snails-backend-command))
    ("@" '(snails-backend-imenu))
    ("#" '(snails-backend-current-buffer))
    ("!" '(snails-backend-rg))
    ("?" '(snails-backend-everything))
    ;;(")" '(snails-backend-everything))
    )
  "The prefix/backends pair."
  :type 'cons)
;; ( 1. var config
;; ( 2. diy functions
;; ( 3. use-package



;;;;;;;;;;;;;;;;;;;;;
;; ( 1. var config
;;;;;;;;;;;;;;;;;;;;;


;; Email related



;;(window-buffer (other-window 1) )
;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super) ; Left Windows key
(setq w32-pass-apps-to-system nil)
(global-set-key (kbd "<s-x>") 'kill-region)
(global-set-key (kbd "<s-v>") 'yank)


;; org-capture


(global-set-key (kbd "C-c o") 'org-capture)

;; english date
(setq system-time-locale "C")




;; https://gist.github.com/webbj74/0ab881ed0ce61153a82e org file+function example
;; http://ergoemacs.org/emacs/elisp_idioms_prompting_input.html
(require 'ido)
(defun b1/find-arewexyet-entry ()
  "Find arewexyet entry"
  (interactive)
  (goto-char (point-min))
  (setq  choices '("pop" "111" "dragon" "777"))
  (setq hd (ido-completing-read "Select entry:" choices ))  
  (if (re-search-forward (format org-complex-heading-regexp-format (regexp-quote hd)) nil t)
      (goto-char (point-at-bol)) (message "can't found head")
      )
  ;;(org-end-of-subtree)
  )

  ; :PROPERTIES:
  ; :CREATED_AT: 123
  ; :END:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ( 2. diy functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun init_reload ()
  "reload init.el"
  (interactive)
  (load-file "~/.emacs.d/init.el")
  )

(defun init_edit ()
  "open init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el")
  )




(defun open_shell()
  "ctrl-`"
  (interactive)
  (delete-other-windows)
  (split-window-below -10)
  (other-window 1)
  (eshell)
  )
(global-set-key (kbd "<C-`>") 'open_shell)
(global-set-key (kbd "<C-M-return>") 'open_shell)


(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key (kbd "C-d") 'duplicate-line)


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





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ( 3. use-package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Vim key bindings
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-key
  "cc" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
 ;; "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "."  'evilnc-copy-and-comment-operator
  ;;"w" 'evi
  "\\" 'evilnc-comment-operator ; if you prefer backslash key
)
(use-package company
  :ensure t
  )

(use-package rustic
  :ensure t
  )


(use-package nov
  :ensure t

  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  ;;(setq nov-unzip-program "D:\\installed\\Git\\usr\\bin\\unzip.exe")
;;  (setq nov-unzip-program "C:\\Program Files\\Git\\usr\\bin\\unzip.exe")
  (setq nov-unzip-program "Q:\\Downloads\\w64devkit-fortran-1.21.0\\w64devkit\\bin\\unzip.exe")
;; (defun my-nov-font-setup ()
;;   (face-remap-add-relative 'variable-pitch :family "Merriweather"
;;                                            :height 1.2))
;; (add-hook 'nov-mode-hook 'my-nov-font-setup)

	 )




(use-package lsp-mode
  :ensure t
  :hook (
	 (python-mode . lsp)
	 )
  :commands lsp)

					;(use-package lsp-ui
					;  :ensure t
;;  )

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred


(use-package which-key
  :ensure t
  :config
  (which-key-mode))


(use-package evil
  :ensure t
  ;;  :hook (
  ;;(python-mode . evil-mode)
  ;;	 )
  :config
  ;;(evil-set-initial-state 'dired-mode 'emacs)
  ;;(evil-mode 1)
  ;;(evil-mode 0)
  ;; https://emacs.stackexchange.com/questions/9583/how-to-treat-underscore-as-part-of-the-word
  (defalias 'forward-evil-word 'forward-evil-symbol)  
  :commands evil-mode
  )

(use-package general
  :ensure t
  :demand t
  :config
  (general-evil-setup)

  (general-create-definer lc/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer lc/local-leader-keys
    :states '(normal visual)
    :keymaps 'override
    :prefix ","
    :global-prefix "SPC m")

  (lc/leader-keys
    "SPC" '(execute-extended-command :which-key "execute command")
    "`" '((lambda () (interactive) (switch-to-buffer (other-buffer (current-buffer) 1))) :which-key "prev buffer")
    
    ";" '(eval-expression :which-key "eval sexp")

    "b" '(:ignore t :which-key "buffer")
    "br"  'revert-buffer
    ;; "bs" '((lambda () (interactive)
    ;;          (pop-to-buffer "*scratch*"))
    ;;        :wk "scratch")
    "bd"  'kill-current-buffer
    "bb" 'ivy-switch-buffer

    "c" '(:ignore t :which-key "code")

    "f" '(:ignore t :which-key "file")
    "fD" '((lambda () (interactive) (delete-file (buffer-file-name))) :wk "delete")
    "ff"  'find-file
    "fs" 'save-buffer
    "fr" 'recentf-open-files
    "fR" '((lambda (new-path)
             (interactive (list (read-file-name "Move file to: ") current-prefix-arg))
             (rename-file (buffer-file-name) (expand-file-name new-path)))
           :wk "move/rename")

    "g" '(:ignore t :which-key "git")
    "gg" 'magit
    ;; keybindings defined in magit

    "h" '(:ignore t :which-key "describe")
    "he" 'view-echo-area-messages
    "hf" 'describe-function
    "hF" 'describe-face
    "hl" 'view-lossage
    "hL" 'find-library
    "hm" 'describe-mode
    "hk" 'describe-key
    "hK" 'describe-keymap
    "hp" 'describe-package
    "hv" 'describe-variable

    "k" '(:ignore t :which-key "kubernetes")
    ;; keybindings defined in kubernetes.el

    "o" '(:ignore t :which-key "org")
    ;; keybindings defined in org-mode

    ;; "p" '(:ignore t :which-key "project")
    ;; keybindings defined in projectile
    "r" 'rg
    "s" '(:ignore t :which-key "search")
    ;; keybindings defined in consult

    "t"  '(:ignore t :which-key "toggle")
    "t d"  '(toggle-debug-on-error :which-key "debug on error")
    "t l" '(display-line-numbers-mode :wk "line numbers")
    "t w" '((lambda () (interactive) (toggle-truncate-lines)) :wk "word wrap")
    "t +" '(lc/increase-font-size :wk "+ font")
    "t -" '(lc/decrease-font-size :wk "- font")
    "t 0" '(lc/reset-font-size :wk "reset font")

    "u" '(universal-argument :wk "universal")

    "w" '(:ignore t :which-key "window")
    "wl"  'windmove-right
    "ww"  'other-window
    "wh"  'windmove-left
    "wk"  'windmove-up
    "wj"  'windmove-down
    "wr" 'winner-redo
    "wd"  'delete-window
    "w=" 'balance-windows-area
    "wD" 'kill-buffer-and-window
    "wu" 'winner-undo
    "wr" 'winner-redo
    "wm"  '(delete-other-windows :wk "maximize")

    "x" '(:ignore t :which-key "browser")
    ;; keybindings defined in xwwp
     ) 

  (lc/local-leader-keys
    :states 'normal
    "d" '(:ignore t :which-key "debug")
    "e" '(:ignore t :which-key "eval")
    "t" '(:ignore t :which-key "test")))

;(use-package org-journal
 ; :ensure t
 ; :defer t
 ; :init
  ;; Change default prefix key; needs to be set before loading org-journal
 ; (setq org-journal-prefix-key "C-c j ")
;  :config
;  (setq
   ;;org-journal-dir "D:/nextcloud-sync/Documents/day.org"
;        org-journal-date-format "%A, %d %B %Y"
;	org-journal-file-type 'monthly
;	org-journal-encrypt-journal t
;	)  )

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)

  :init
  (setq markdown-command "multimarkdown")
  ;; https://emacs.stackexchange.com/questions/13189/github-flavored-markdown-mode-syntax-highlight-code-blocks
  (setq markdown-fontify-code-blocks-natively t)

  )


;;https://github.com/syl20bnr/spacemacs/issues/11798
;; enable < s TAB
(require 'org-tempo)


;;https://thraxys.wordpress.com/2016/01/14/pimp-up-your-org-agenda/
(use-package org-bullets
  :ensure t
  :init
  (setq org-bullets-bullet-list
	'("◉" "◎" "☆" "○" "►" "◇"))
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;;(setq org-agenda-files (list "d:/working/wiki/src/read.org" "d:/working/plan.org"))
(setq org-agenda-files (list "D:/nextcloud-sync/org-roam/capture/cap_journal.org"))

;;(use-package ccls
;;	    :ensure t
;;	    :config
;;	    (setq ccls-executable "/path/to/ccls/Release/ccls")
;;	    )
(use-package ivy
  :ensure t
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  ;;(global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  ;;(global-set-key (kbd "M-x") 'counsel-M-x)
;;  (global-set-key (kbd "M-x") 'M-x)
     (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  )

;; https://github.com/lassik/emacs-format-all-the-code
;;(use-package format-all-buffer
  ;;:ensure t
  ;;)

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings) ;; 设置以 C-c s 开头的 keymap
  :commands rg
  ;;  C-c s d (rg-dwim)
  )


(use-package pangu-spacing
  :ensure t
  :config
  (add-hook 'markdown-mode-hook
            '(lambda ()
               (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)
	       ;;(setq global-pangu-spacing-mode 1)
	       ))
  (add-hook 'org-mode-hook
            '(lambda ()
               (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)
	       ;;(setq global-pangu-spacing-mode 1)
	       ;;(setq pangu-spacing-real-insert-separtor t)
	       ))
  )

;; https://www.reddit.com/r/emacs/comments/mjzq1p/shoutout_to_smooth_scrolling_experience_with/
(use-package good-scroll
  :ensure t
  :commands good-scroll-mode
  )


(global-set-key (kbd "C-S-o") 'helm-grep-do-git-grep)
(global-set-key (kbd "C-c b") 'compile)

(add-hook 'c-mode-hook
          (lambda () (local-set-key (kbd "<f5>")

				    (lambda () (interactive)
				      (compile (concat "clxp "
						       ;;(file-name-sans-extension buffer-file-name)
						       buffer-file-name

						       ))))
	    ))
(add-hook 'cpp-mode-hook
          (lambda () (local-set-key (kbd "<f5>")

				    (lambda () (interactive)
				      (compile (concat "clxp "
						       ;;(file-name-sans-extension buffer-file-name)
						       buffer-file-name

						       ))))
	    ))

;; (define-key c-mode-map (kbd "<f5>") (lambda () (interactive) (compile (concat "clxp " (file-name-sans-extension buffer-file-name))) ))


;;; font

;; https://emacs-china.org/t/topic/13710/31
;;(set-face-attribute 'default nil :font "DejaVu Sans Mono 12")
(set-face-attribute 'default nil :font "Jetbrains Mono 12")
;;(set-face-attribute 'default nil :font "Sarasa Term SC 12")
;; Setting Chinese Font

;; (setq cn-font "Sarasa Term SC")
;; ;;(setq cn-font "yozai")
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     charset
;;                     (font-spec :family cn-font))
;;   (setq face-font-rescale-alist '((cn-font . 1))))

;; 测试abcABC
(set-fontset-font t 'han (font-spec :family "Microsoft Yahei" :size 16))
(setq face-font-rescale-alist '(("Microsoft Yahei" . 1.4) ("WenQuanYi Zen Hei" . 1.4)))


;;(setq tramp-default-method "plinkxx")








;; https://emacs.stackexchange.com/a/52933

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t (:inherit fixed-pitch :family "Consolas"))))
 '(whitespace-missing-newline-at-eof ((t nil)))
 '(whitespace-newline ((t (:foreground "white" :weight thin)))))
