(use-package lsp-mode
  :init
  (progn
    (setq lsp-prefer-flymake nil)
    (setq lsp-session-file (expand-file-name "lsp-session-v1" sjj-savefile-dir)))
  :commands lsp
  :ensure t)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

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
  (flyspell-prog-mode)
  (smartparens-mode +1))

(add-hook 'prog-mode-hook 'sjj-prog-mode-defaults)

(setq projectile-project-compilation-cmd "")

(require 'kubectx)
(kubectx-mode 1)

(provide 'programming-setup)
