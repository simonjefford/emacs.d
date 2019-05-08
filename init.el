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
(require 'general-editor-setup)
(require 'go-setup)
(require 'rust-setup)

(use-package discover-my-major
  :ensure t)

(server-start)

(use-package xkcd
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md" . gfm-mode)
	 ("\\.markdown" . gfm-mode)))

(defun emacs-lisp-setup()
  (progn
    (smartparens-strict-mode +1)
    (eldoc-mode +1)
    (whitespace-mode -1)))

(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-setup)

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(defun recompile-init ()
  (interactive)
  (byte-recompile-directory emacsd 0))
