;;; init.el  -*- lexical-binding: t; -*-
(defvar emacsd (file-name-directory load-file-name))
(defvar main-config-dir (expand-file-name "config" emacsd))
(defvar modes-dir (expand-file-name "modes" emacsd))
(defvar vendor-dir (expand-file-name "vendor" emacsd))

;; Log every warning to *Warnings*, but only pop that window up for emergencies.
;; Check it with (switch-to-buffer "*Warnings*") when needed.
(setq warning-minimum-level :emergency)

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
;; vendored without an autoloads file; loading it eagerly pulls in dired
(use-package git-link
  :commands (git-link git-link-commit git-link-homepage))
(require 'bb)
(require 'projectile-setup)
(require 'helm-setup)
(require 'python-setup)
(require 'ibuffer-setup)
(require 'general-editor-setup)
(require 'programming-setup)
(require 'emacs-lisp-setup)
(require 'go-setup)
(require 'rust-setup)
(require 'terraform-setup)
(require 'org-setup)
(require 'markdown-setup)
(require 'ruby-setup)
(require 'slides-mode)
(require 'r-setup)
(require 'structurizr-mode)

;; (require 'quelpa-setup)
;; (require 'copilot-setup)

(use-package discover-my-major
  :ensure t
  :defer t)

(server-start)

(use-package xkcd
  :ensure t
  :defer t)

(defun recompile-init ()
  (interactive)
  (byte-recompile-directory emacsd 0))

(use-package highlight-indentation
  :ensure
  :defer)

(add-hook 'yaml-mode-hook 'highlight-indentation-mode)

(diminish-all-the-things)
(put 'set-goal-column 'disabled nil)

(use-package envrc
  :ensure
  :config (envrc-global-mode))
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)

(defun generate-eks-manifest ()
  (interactive)
  (let* ((file-path (buffer-file-name))
	 (eks-match (string-match "/eks-service-manifests/" file-path))
	 (eks-manifests-dir (when eks-match
                              (substring file-path 0 (match-end 0))))
	 (after-eks (when eks-match
                      (substring file-path (match-end 0))))
	 (sourcedir (when eks-manifests-dir
                      (file-name-directory (directory-file-name eks-manifests-dir))))
	 (manifestpath (when after-eks
			 (file-name-directory after-eks)))
	 (service (file-name-base file-path))
	 (default-directory eks-manifests-dir))
    (when (and eks-manifests-dir manifestpath service)
      (shell-command (format "thredd-eks-generator generate -i %s%s.yaml -o %s%s"
                             manifestpath service manifestpath service)))))

(bind-key "C-x t e" 'generate-eks-manifest)

(use-package vterm
  :load-path  "/Users/simon/src/oss/emacs-libvterm"
  :commands (vterm vterm-other-window))

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools
