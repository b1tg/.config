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



(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(setq custom-file "~/.emacs.d/custom-file.el")

(package-initialize)

(unless
    (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(load "~/.emacs.d/priv.el")
(load "~/.emacs.d/init-pre.el")
;; (load "~/.emacs.d/local/simpc-mode.el")
;; (load "~/.emacs.d/init-trash.el") ;; discard later

(setq org-agenda-include-diary t)

;; so you can use emacsclientw.exe -n <filename>
(server-start)

(global-display-line-numbers-mode)
(use-package wakatime
  :ensure t
  :config
  (global-wakatime-mode)
  )

;; fix python utf8 warning
(define-coding-system-alias 'UTF-8 'utf-8)

(global-set-key (kbd "C-SPC") 'set-mark-command)
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "C-`") 'ace-window)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-x C-z") 'undo-redo)

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
	   (if logseq-p
	       "../assets"
	     "assets"
	     )
	   "/"
           (format-time-string "%Y%m%d_%H%M%S_")) )
	 ".png"))
  (print filename)
  (shell-command (concat "Q:/write-code/clip.exe " filename))
  (if md-p
      (insert (concat "![image.png](" filename ")"))
    (insert (concat "[[file:" filename "]]"))
    )
  )

(setq org-directory "Q:/org-mode")
(setq org-download-image-dir "Q:/org-mode/download-image")

;; https://www.reddit.com/r/emacs/comments/5pziif/cd_to_home_directory_of_server_when_using_eshell/
(defun eshell/cd- (new-path)
  (let* ((d default-directory)
         (s (split-string d ":"))
         (path (car (last s)))
         (l (length path))
         (host (substring d 0 (- (length d) l))))
    (eshell/cd (format "%s%s" host new-path))))

;;(window-buffer (other-window 1) )
;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super) ; Left Windows key
(setq w32-pass-apps-to-system nil)
(global-set-key (kbd "<s-x>") 'kill-region)
(global-set-key (kbd "<s-v>") 'yank)
(global-set-key (kbd "C-c o") 'org-capture)

;; english date
(setq system-time-locale "C")

(setq compilation-scroll-output t)

;; ripgrep as grep
;; https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-prog.el
;; https://github.com/BurntSushi/ripgrep/issues/1892
(require 'grep)
(grep-apply-setting 'grep-command "rg --color auto --path-separator / --no-heading -n    ./")
(setq grep-command-position 53)

;; https://gist.github.com/webbj74/0ab881ed0ce61153a82e org file+function example
;; http://ergoemacs.org/emacs/elisp_idioms_prompting_input.html
(require 'ido)

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


(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))
;; (global-set-key (kbd "C-d") 'rc/duplicate-line)
(global-set-key (kbd "C-,") 'rc/duplicate-line)

;;(require 'simpc-mode)
;;(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

(add-hook 'c-mode-hook
          (lambda ()
            (local-unset-key (kbd "C-d"))
            (local-set-key (kbd "C-d") 'mc/mark-more-like-this-extended)))
(add-hook 'c++-mode-hook
          (lambda ()
            (local-unset-key (kbd "C-d"))
            (local-set-key (kbd "C-d") 'mc/mark-more-like-this-extended)))


(global-set-key (kbd "M-f") 'swiper)
(global-set-key (kbd "C-]") 'xref-find-definitions)
;;(global-set-key (kbd "C-[") 'xref-pop-marker-stack)

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

(defun lc/code ()
  "Open with vscode"
  (interactive)
  (let ((code-path
         (cond
          ((eq system-type 'windows-nt)
           (or (executable-find "code")
               (let ((vscode-path "C:/Users/%USERNAME%/AppData/Local/Programs/Microsoft VS Code/bin/code"))
                 (if (file-exists-p (expand-file-name vscode-path))
                     (expand-file-name vscode-path)
                   (error "Could not find VSCode executable. Please ensure 'code' is in your PATH")))))
          (t "code")))  ; On Unix-like systems, assume 'code' is in PATH
        (file-or-dir
         (if (buffer-file-name)
             (buffer-file-name)
           (read-directory-name "Select directory to open in VSCode: " default-directory))))
    (if (file-exists-p file-or-dir)
        (start-process "vscode" nil code-path file-or-dir)
      (error "File or directory does not exist: %s" file-or-dir))
    (message "Opened %s in VSCode" file-or-dir)))


(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-;") 'er/expand-region)
  )


(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-<up>") 'move-text-up)
  (global-set-key (kbd "M-<down>") 'move-text-down)
  )

(use-package company
  :ensure t
  )

(use-package nov
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (setq nov-unzip-program "Q:\\Downloads\\w64devkit-x64-2.0.0\\w64devkit\\bin\\unzip.exe")
  (defun my-nov-font-setup ()
    (face-remap-add-relative 'variable-pitch :family "Merriweather"
                             :height 1.2))
  (add-hook 'nov-mode-hook 'my-nov-font-setup)
  )

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "multimarkdown")
  ;; https://emacs.stackexchange.com/questions/13189/github-flavored-markdown-mode-syntax-highlight-code-blocks
  (setq markdown-fontify-code-blocks-natively t))


;;https://github.com/syl20bnr/spacemacs/issues/11798
;; enable < s TAB
(require 'org-tempo)


;;https://thraxys.wordpress.com/2016/01/14/pimp-up-your-org-agenda/
(use-package org-bullets
  :ensure t
  :init
  (setq org-bullets-bullet-list '("◉" "◎" "☆" "○" "►" "◇"))
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-agenda-files (list "D:/nextcloud-sync/org-roam/capture/cap_journal.org"))


(use-package magit
  :ensure t
  )
(use-package smex
  :ensure t
  )
(use-package counsel
  :ensure t
  )
(use-package ivy
  :ensure t
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  )

(use-package format-all
  :ensure t
  )

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings) ;; 设置以 C-c s 开头的 keymap
  :commands rg
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

;;; multiple cursors
(use-package multiple-cursors
  :ensure t
  :config
  (define-key mc/keymap (kbd "<return>") nil) ;; make <enter> not exit
  (global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click) ;; multi click
  ;;  (global-set-key (kbd "C-M-c") 'mc/mark-more-like-this-extended) ;; vscode like, use arrow key
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->")         'mc/mark-next-like-this)
  ;; 模拟vscode，两种用法：直接按c-d选多行、高亮单词选高亮
  ;; 选到当前视图以外的词需要手动滚动屏幕：Scroll down with C-v, scroll up with M-v
  (global-set-key (kbd "C->")         'mc/mark-more-like-this-extended)
  (global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
  (global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
  (global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)
  )

					; Treat hyphen and underscore as word constituent
(modify-syntax-entry ?- "w")
(modify-syntax-entry ?_ "w")


(defun my-kill-region-or-backward-word ()
  "Kill region if active, otherwise kill word before point within current line.
If at beginning of line, does nothing to avoid deleting previous line."
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (let ((pos (point))
          (bol (line-beginning-position)))
      (if (= pos bol)
          (message "At beginning of line")
        ;; Save current point and move backward by word
        (save-excursion
          (backward-word)
          ;; Only kill if we're still on the same line
          (if (>= (point) bol)
              (kill-region (point) pos)
            (let ((word-end pos)
                  (word-start bol))
              ;; Kill from beginning of line to current position
              (kill-region word-start word-end))))))))
(global-set-key "\C-w" 'my-kill-region-or-backward-word)


(defun my-quit-minibuffer ()
  "Jump to minibuffer window if it's active and simulate real C-g behavior."
  (interactive)
  (if (active-minibuffer-window)
      (progn
        ;; 直接中止 minibuffer
        (abort-recursive-edit)
        ;; 如果是 isearch，确保它也被取消
        (when (bound-and-true-p isearch-mode)
          (isearch-cancel)))
    (message "No active minibuffer")))
(global-set-key (kbd "C-S-g") 'my-quit-minibuffer)



(setq dired-listing-switches "-alFh")

;; claude
;; 1. write a function in emacs search word at cursor in current folder use ripgrep
;; 2. 如果有选择区域，搜索选择区域
(defun rg-search-word-or-region ()
  "Search for selected text or word at cursor in current directory using ripgrep.
If region is active, search for the selected text,
otherwise search for the word at cursor position.
Requires ripgrep (rg) to be installed on the system."
  (interactive)
  (let ((search-text (if (use-region-p)
                         (buffer-substring-no-properties (region-beginning) (region-end))
                       (thing-at-point 'word t)))
        (dir default-directory))
    (if search-text
        (progn
          ;; Convert search text to literal string (escape all special characters)
	  ;; 正则搞不定，全字匹配
          ;; (setq search-text1
          ;;       (replace-regexp-in-string
          ;;        "[][()\\.*+?^$]" "\\\\\\&"
          ;;        (replace-regexp-in-string "\n" "\\n" search-text)))
          ;; Use compile-mode for ripgrep output with fixed string search
          (compilation-start
           (concat "rg --line-number --no-heading --color never --multiline "
                   "--fixed-strings "  ; 使用固定字符串搜索而不是正则表达式
                   (shell-quote-argument search-text)
                   " "
                   (shell-quote-argument dir))
           'grep-mode
           (lambda (mode)
             (format "*rg-search-%s*"
                     (truncate-string-to-width search-text 30 nil nil "...")))))
      (message "No text selected or word at cursor"))))
;; Optional: Add key binding
(global-set-key (kbd "C-c r") 'rg-search-word-or-region)
;; Optional: Make the *rg-search* buffer auto-revert
(add-hook 'grep-mode-hook (lambda () (auto-revert-mode t)))


(global-set-key (kbd "C-S-o") 'helm-grep-do-git-grep)
(global-set-key (kbd "C-c b") 'compile)
(global-set-key (kbd "C-x f") 'find-file-at-point)


(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))



(defun lc/set-buffer-utf8 ()
  "Set current buffer's coding system to UTF-8 and revert the buffer."
  (interactive)
  (when (buffer-file-name)
    (let ((coding-system-for-read 'utf-8))
      (revert-buffer-with-coding-system 'utf-8)
      (message "Buffer encoding set to UTF-8 and reverted."))))



(setq org-support-shift-select t)



;; https://emacs-china.org/t/topic/13710/31
;; https://github.com/be5invis/Sarasa-Gothic
;; (set-face-attribute 'default nil :font "Jetbrains Mono 14")
(set-face-attribute 'default nil :font "Sarasa Term SC 16") ;; 等高字体
(set-face-attribute 'default nil :font "Sarasa Term SC Nerd 16") ;; 等高字体
