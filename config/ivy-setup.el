(use-package counsel
  :ensure t)

(use-package smex
  :ensure t)

(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t)
  :bind (("C-x C-m" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-x b" . ivy-switch-buffer))
  :ensure t)

(use-package ivy-hydra
  :ensure t)

(provide 'ivy-setup)

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode +1))
