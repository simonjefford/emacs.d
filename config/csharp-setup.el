(eval-after-load
    'company
  '(add-to-list 'company-backends 'company-omnisharp))

(use-package omnisharp
  :ensure t
  :bind (:map csharp-mode-map
	      ("M-." . omnisharp-go-to-definition))
  :defer)

(defun sjj-csharp-mode-hook()
  (omnisharp-mode)
  (company-mode)
  (setq indent-tabs-mode nil))

(use-package csharp-mode
  :ensure t
  :config (add-hook 'csharp-mode-hook #'sjj-csharp-mode-hook))

(provide 'csharp-setup)
