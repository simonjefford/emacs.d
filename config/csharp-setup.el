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

(provide 'csharp-setup)
