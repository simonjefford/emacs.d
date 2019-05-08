(use-package projectile
  :ensure t
  :bind (("M-t" . 'projectile-find-file))
  :init
  (setq projectile-switch-project-action 'projectile-vc)
  :bind-keymap
  ("s-p" . projectile-command-map)
  :config
  (projectile-mode +1))

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode +1))

(provide 'projectile-setup)
