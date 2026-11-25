;;; go-setup.el  -*- lexical-binding: t; -*-
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
  :ensure t
  :defer t)

(use-package go-projectile
  :ensure t
  :after (projectile go-mode))

(use-package gotest :ensure t :defer t)

(provide 'go-setup)
