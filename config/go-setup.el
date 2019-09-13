(use-package go-mode
  :config
  (progn
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save)
    (add-hook 'go-mode-hook #'company-mode)
    (subword-mode)
    (add-hook 'go-mode-hook #'lsp-deferred))
    :bind (:map go-mode-map
	      ("M-." . lsp-ui-peek-find-definitions))
  :ensure t)

(use-package go-guru
  :ensure t)

(use-package go-projectile
  :ensure t)

(use-package gotest :ensure t)

(provide 'go-setup)
