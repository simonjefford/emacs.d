(defvar emacsd (file-name-directory load-file-name))
(defvar main-config-dir (expand-file-name "config" emacsd))

(add-to-list 'load-path main-config-dir)

(require 'package-setup)
(require 'ui)
(require 'macos)
(require 'git)
(require 'ivy-setup)
(require 'projectile-setup)
(require 'ibuffer-setup)

(use-package crux
  :ensure t)

(use-package discover-my-major
  :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package rust-mode
  :ensure t)

(use-package browse-kill-ring
  :bind (("s-y" . browse-kill-ring))
  :ensure t)

(use-package go-mode
  :config
  (progn
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save))
  :ensure t)

(use-package go-guru
  :bind (:map go-mode-map
	      ("M-." . go-guru-definition))
  :ensure t)

(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))

(server-start)

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
(bind-key "C-w" 'backward-kill-word)

(bind-key "M-`" 'other-frame)

(use-package xkcd
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md" . gfm-mode)
	 ("\\.markdown" . gfm-mode)))

(use-package smartparens
  :ensure t
  :init
  (progn
    (setq sp-base-key-bindings 'paredit)
    (setq sp-autoskil-closing-pair 'always)
    (setq sp-hybrid-kill-entire-symbol nil))
  :config
  (progn
    (require 'smartparens-config)
    (sp-use-paredit-bindings)
    (show-smartparens-global-mode +1)))

(defun emacs-lisp-setup()
  (progn
    (smartparens-strict-mode +1)
    (eldoc-mode +1)
    (whitespace-mode -1)))

(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-setup)

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(winner-mode +1)
