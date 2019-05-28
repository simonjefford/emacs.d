(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-light t))

(defun go-dark ()
  (interactive)
  (load-theme 'spacemacs-dark)
  (spaceline-compile))

(defun go-light ()
  (interactive)
  (load-theme 'spacemacs-light)
  (spaceline-compile))

(bind-key "C-x t d" 'go-dark)
(bind-key "C-x t l" 'go-light)

;; stuff to put into spaceline
(use-package winum :ensure t)
(use-package eyebrowse :ensure t)
(use-package persp-mode :ensure t)
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
  :ensure t)

(defun diminish-all-the-things ()
  (interactive)
  (mapcar 'diminish (list 'editorconfig-mode
			'which-key-mode
			'projectile-mode
			'smartparens-mode
			'eldoc-mode
			'anzu-mode
			'highlight-indentation-mode
			'company-mode
			'flyspell-mode
			'omnisharp-mode)))

(provide 'ui)
