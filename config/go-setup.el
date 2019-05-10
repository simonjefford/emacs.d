(use-package go-mode
  :config
  (progn
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save))
  :ensure t)

(use-package go-guru
  :bind (:map go-mode-map
	      ("M-." . go-guru-definition))
  :ensure t)


(use-package go-projectile
  :ensure t)

(provide 'go-setup)
