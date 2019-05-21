(use-package projectile
  :ensure t
  :bind (("M-t" . 'projectile-find-file))
  :init
  (setq projectile-switch-project-action 'projectile-find-file)
  :bind-keymap
  ("s-p" . projectile-command-map)
  :config
  (projectile-mode +1))

(provide 'projectile-setup)
