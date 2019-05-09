(unbind-key "s-m")

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
	 ("s-m b" . magit-blame-addition)))

(use-package git-timemachine
  :ensure t)

(use-package diff-hl
  :ensure t
  :config
  (progn
    (global-diff-hl-mode +1)
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

(provide 'git)
