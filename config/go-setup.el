(defun subword-alert()
  (message "subword mode loaded"))

(add-hook 'subword-mode-hook #'subword-alert)

(use-package go-mode
  :defer t
  :config
  (progn
    (message "configuring go-mode")
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save)
    (add-hook 'go-mode-hook #'subword-mode)
    (add-hook 'go-mode-hook #'company-mode)
    (add-hook 'go-mode-hook #'lsp-deferred))

  :bind
  (:map go-mode-map
	("M-." . lsp-ui-peek-find-definitions))
  :ensure t)

(use-package go-guru
  :ensure t)

(use-package go-projectile
  :ensure t)

(use-package gotest :ensure t)

(provide 'go-setup)
