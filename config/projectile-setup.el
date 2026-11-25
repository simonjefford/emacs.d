;;; projectile-setup.el  -*- lexical-binding: t; -*-
(use-package projectile
  :ensure t
  ;; Was only loaded at startup as a side effect of helm-projectile; keep
  ;; projectile-mode on (project tracking) but start it after init.
  :defer 1
  :diminish projectile-mode
  :bind (("M-t" . 'projectile-find-file))
  :init
  (setq projectile-switch-project-action 'projectile-find-file)
  :bind-keymap
  ("s-p" . projectile-command-map)
  :config
  (projectile-mode +1))

(provide 'projectile-setup)
