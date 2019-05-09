(defun sjj-terraform-hook()
  (progn
    (terraform-format-on-save-mode)
    (company-mode +1)))

(use-package terraform-mode
  :ensure t
  :config
  (progn
    (add-hook 'terraform-mode-hook 'sjj-terraform-hook)))

(use-package company-terraform
  :ensure t
  :config (company-terraform-init))

(provide 'terraform-setup)
