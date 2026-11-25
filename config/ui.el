;;; ui.el  -*- lexical-binding: t; -*-
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setopt ring-bell-function 'ignore)

;; disable startup screen
(setopt inhibit-startup-screen t)

;; nice scrolling
(setopt scroll-margin 0
	scroll-conservatively 100000
	scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

(use-package spacemacs-theme
  :ensure t
  :defer t
  :init (load-theme 'spacemacs-light t))

(use-package twilight-anti-bright-theme :ensure t :defer t)

(use-package batppuccin :ensure t :defer t)

(use-package subatomic-theme :ensure t :defer t)

(use-package subatomic256-theme :ensure t :defer t)

(defun sjj-batppuccin ()
  (interactive)
  (reset-themes)
  (load-theme 'batppuccin-mocha)
  (spaceline-compile))

(defun reset-themes ()
  (dolist (i custom-enabled-themes)
    (disable-theme i)))

(defun sjj-go-dark ()
  (interactive)
  (reset-themes)
  (load-theme 'batppuccin-mocha)
  (spaceline-compile))

(defun sjj-go-light ()
  (interactive)
  (reset-themes)
  (load-theme 'batppuccin-latte)
  (spaceline-compile))

(defun sjj-twilight ()
  (interactive)
  (reset-themes)
  (load-theme 'twilight-anti-bright)
  (spaceline-compile))

(defun my-apply-theme (appearance)
  "Load theme based on APPEARANCE (light or dark)."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'batppuccin-latte t))
    ('dark (load-theme 'batppuccin-mocha t))))

(add-hook 'ns-system-appearance-change-functions #'my-apply-theme)

(defun sjj-subatomic ()
  (interactive)
  (reset-themes)
  (load-theme 'subatomic)
  (spaceline-compile))

(bind-key "C-x t d" 'sjj-subatomic)
(bind-key "C-x t l" 'sjj-go-light)

(bind-key "C-c b" 'browse-url)

(defun name-of-the-file ()
  "Inserts the name of the file the current buffer is based on."
  (interactive)
  (insert (buffer-file-name (window-buffer (minibuffer-selected-window)))))

(bind-key "C-c f" 'name-of-the-file)

(defun sjj-copy-pwd-to-clipboard ()
  (interactive)
  (let ((pwd default-directory))
    (kill-new pwd)
    (message "Copied: %s" pwd)))

(bind-key "C-c p" 'sjj-copy-pwd-to-clipboard)

(defun sjj-copy-buffer-path-to-clipboard ()
  (interactive)
  (let ((path (buffer-file-name)))
    (unless path
      (user-error "Buffer is not visiting a file"))
    (kill-new path)
    (message "Copied: %s" path)))

(bind-key "C-c P" 'sjj-copy-buffer-path-to-clipboard)

(defun sjj-ghostty-here ()
  (interactive)
  (call-process "open" nil nil nil "-a" "Ghostty" default-directory))

(bind-key "C-c i" 'sjj-ghostty-here)

;; stuff to put into spaceline
(use-package winum :ensure t :defer t)
(use-package eyebrowse :ensure t
  :config (eyebrowse-mode t))
(use-package persp-mode :ensure t :defer t)
(use-package anzu
  :ensure t
  :init (setq anzu-cons-mode-line-p nil)
  :config (global-anzu-mode +1))

(use-package spaceline
  :ensure t
  :init (progn
	  (setq powerline-default-separator 'wave))
  :config (progn
	    (require 'spaceline-config)
	    (spaceline-emacs-theme)
	    (spaceline-helm-mode)))

(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'unicode "Symbola" nil 'prepend))

(use-package diminish
  :ensure t
  :defer t)

(defun diminish-all-the-things ()
  (interactive)
  (mapc 'diminish '(editorconfig-mode
		    which-key-mode
		    projectile-mode
		    smartparens-mode
		    helm-mode
		    eldoc-mode
		    anzu-mode
		    yas-global-mode
		    highlight-indentation-mode
		    company-mode
		    flyspell-mode
		    yas-minor-mode
		    omnisharp-mode)))

(when (or (eq system-type 'darwin) (eq system-type 'gnu/linux))
  (set-face-attribute 'default nil
                    :family "MesloLGS NF" :height 140 :weight 'normal))

;; elgrep (pulled in by obsidian) rewrites elgrep-data.el on exit without a
;; lexical-binding cookie, which Emacs 31 warns about. We don't use its history.
(setq elgrep-data-file nil)

;; Instead of global-obsidian-mode (which loads obsidian, markdown-mode and
;; elgrep at every startup), turn obsidian-mode on only for markdown files in
;; the vault. gfm-mode derives from markdown-mode, so this covers .md files.
(defun sjj-obsidian-directory ()
  "The vault directory, even before obsidian is loaded.
Customize only sets the variable once its package loads; until then the
value sits in the symbol's `saved-value'."
  (or (bound-and-true-p obsidian-directory)
      (let ((saved (get 'obsidian-directory 'saved-value)))
        (and saved (eval (car saved) t)))))

(defun sjj-obsidian-maybe-enable ()
  (when-let* ((vault (sjj-obsidian-directory))
              ((stringp vault))
              (file buffer-file-name)
              ((string-prefix-p (expand-file-name vault)
                                (expand-file-name file))))
    (require 'obsidian)
    (obsidian-enable-minor-mode)))

(use-package obsidian
  :ensure t
  :defer t
  :init (add-hook 'markdown-mode-hook #'sjj-obsidian-maybe-enable))

(global-hl-line-mode)

(provide 'ui)
