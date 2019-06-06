(defvar emacsd (file-name-directory load-file-name))
(defvar main-config-dir (expand-file-name "config" emacsd))
(defvar modes-dir (expand-file-name "modes" emacsd))
(defvar vendor-dir (expand-file-name "vendor" emacsd))

(add-to-list 'load-path main-config-dir)
(add-to-list 'load-path modes-dir)
(add-to-list 'load-path vendor-dir)

(require 'package-setup)
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))
(require 'ui)
(when (eq system-type 'darwin)
  (require 'macos))
(require 'git)
(require 'projectile-setup)
(require 'helm-setup)
(require 'ibuffer-setup)
(require 'general-editor-setup)
(require 'programming-setup)
(require 'emacs-lisp-setup)
(require 'go-setup)
(require 'rust-setup)
(require 'csharp-setup)
(require 'terraform-setup)
(require 'org-setup)
(require 'markdown-setup)

(require 'slides-mode)

(use-package discover-my-major
  :ensure t)

(server-start)

(use-package xkcd
  :ensure t)

(defun recompile-init ()
  (interactive)
  (byte-recompile-directory emacsd 0))

(use-package highlight-indentation
  :ensure
  :defer)

(add-hook 'yaml-mode-hook 'highlight-indentation-mode)

(diminish-all-the-things)
