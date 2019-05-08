(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package git-timemachine
  :ensure t)

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode +1))

(provide 'git)
