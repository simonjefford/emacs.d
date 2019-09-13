(use-package lsp-mode
  :init
  (progn
    (setq lsp-prefer-flymake nil)
    (setq lsp-session-file (expand-file-name "lsp-session-v1" sjj-savefile-dir))
    (setq lsp-auto-guess-root 't))
  :commands (lsp lsp-deferred)
  :ensure t)

(use-package lsp-ui
  :init
  (progn
    (setq lsp-ui-sideline-enable nil))
  :ensure t
  :commands lsp-ui-mode)

(use-package typescript-mode
  :ensure t)

(use-package company-lsp
  :ensure t
  :commands company-lsp)

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode +1))

;; "incidental" language setup
(use-package groovy-mode
  :init (add-to-list 'auto-mode-alist '("Jenkinsfile\\'" . groovy-mode))
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package protobuf-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(use-package yasnippet
  :ensure t)

(use-package gist
  :ensure t)

(use-package powershell :ensure t)

(use-package evil-nerd-commenter
  :ensure t
  :config (evilnc-default-hotkeys))

(setq compilation-ask-about-save nil)

(sp-pair "{" nil :post-handlers
         '(((lambda (&rest _ignored)
              (crux-smart-open-line-above)) "RET")))

(defun sjj-prog-mode-defaults()
  (set (make-local-variable 'comment-auto-fill-only-comments) t)
  (setq flyspell-prog-text-faces '(font-lock-command-face font-lock-doc-face))
  (flyspell-prog-mode)
  (smartparens-mode +1))

(add-hook 'prog-mode-hook 'sjj-prog-mode-defaults)

(setq projectile-project-compilation-cmd "")

(require 'kubectx)
(kubectx-mode 1)

(use-package coffee-mode :ensure t)

(defun sjj-visit-powershell-buffer ()
  (interactive)
  (crux-start-or-switch-to (lambda()
			     (ansi-term "/usr/local/bin/pwsh" "powershell"))
			   "*powershell*"))

(bind-key "C-c s" 'sjj-visit-powershell-buffer)

(provide 'programming-setup)
