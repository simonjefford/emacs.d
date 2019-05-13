(use-package lsp-mode
  :init
  (setq lsp-session-file (expand-file-name "lsp-session-v1" sjj-savefile-dir))
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

(setq compilation-ask-about-save nil)

(provide 'programming-setup)
