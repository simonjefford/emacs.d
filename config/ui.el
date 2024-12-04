(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

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
  :ensure t
  :defer t
  :init (load-theme 'spacemacs-light t))

(use-package twilight-anti-bright-theme :ensure t)

(use-package subatomic-theme :ensure t)

(use-package subatomic256-theme :ensure t)


(defun reset-themes ()
  (dolist (i custom-enabled-themes)
    (disable-theme i)))

(defun sjj-go-dark ()
  (interactive)
  (reset-themes)
  (load-theme 'spacemacs-dark)
  (spaceline-compile))

(defun sjj-go-light ()
  (interactive)
  (reset-themes)
  (load-theme 'spacemacs-light)
  (spaceline-compile))

(defun sjj-twilight ()
  (interactive)
  (reset-themes)
  (load-theme 'twilight-anti-bright)
  (spaceline-compile))

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

;; stuff to put into spaceline
(use-package winum :ensure t)
(use-package eyebrowse :ensure t
  :config (eyebrowse-mode t))
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
			  'helm-mode
			  'eldoc-mode
			  'anzu-mode
			  'yas-global-mode
			  'highlight-indentation-mode
			  'company-mode
			  'flyspell-mode
			  'yas-minor-mode
			  'omnisharp-mode)))

(when (or (eq system-type 'darwin) (eq system-type 'gnu/linux))
  (set-face-attribute 'default nil
                    :family "MesloLGS NF" :height 140 :weight 'normal))

(provide 'ui)
