;;; terraform-setup.el  -*- lexical-binding: t; -*-
(defun sjj-terraform-hook()
  (progn
    (terraform-format-on-save-mode)
    (company-mode +1)))

(use-package terraform-mode
  :ensure t
  :defer t
  :config
  (progn
    (add-hook 'terraform-mode-hook 'sjj-terraform-hook)))

(use-package company-terraform
  :ensure t
  :after terraform-mode
  :config (company-terraform-init))

(provide 'terraform-setup)
