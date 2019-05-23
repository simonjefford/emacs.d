(defvar emacsd (file-name-directory load-file-name))
(defvar main-config-dir (expand-file-name "config" emacsd))

(add-to-list 'load-path main-config-dir)

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

(defun recompile-init ()
  (interactive)
  (byte-recompile-directory emacsd 0))

(use-package highlight-indentation
  :defer)

(add-hook 'yaml-mode-hook 'highlight-indentation-mode)

(diminish-all-the-things)
