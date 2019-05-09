(unbind-key "s-m")

(defun magit-quit-session()
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
	 ("s-m b" . magit-blame-addition)
	 :map magit-status-mode-map
	 ("q" . 'magit-quit-session))
  )

(use-package git-timemachine
  :ensure t)

(use-package diff-hl
  :ensure t
  :config
  (progn
    (global-diff-hl-mode +1)
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(provide 'git)
