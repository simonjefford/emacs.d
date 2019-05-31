(use-package go-mode
  :config
  (progn
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save)
    (add-hook 'go-mode-hook #'company-mode))
  :ensure t)

(use-package go-guru
  :bind (:map go-mode-map
	      ("M-." . go-guru-definition))
  :ensure t)

(use-package company-go
  :ensure t
  :config (add-to-list 'company-backends 'company-go))

(use-package go-projectile
  :ensure t)

(use-package gotest :ensure t)

(require 'lsp-go)

(provide 'go-setup)
