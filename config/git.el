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

(use-package github-browse-file
  :ensure t)

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun sjj-magit-command-in-project-dir (command)
  (let ((command-dir (or (projectile-project-root) default-directory)))
    (magit--shell-command command command-dir)))

(defun sjj-hub-command-in-project-dir (command)
  (sjj-magit-command-in-project-dir (concat "hub " command)))

(defun sjj-hub-browse ()
  (interactive)
  (sjj-hub-command-in-project-dir "browse"))

(defun sjj-hub-pullrequest ()
  (interactive)
  (sjj-hub-command-in-project-dir "pull-request"))

(defun sjj-hub-cistatus ()
  (interactive)
  (sjj-hub-command-in-project-dir "ci-status -v --color=never"))

(defun sjj-hub-create-issue ()
  (interactive)
  (sjj-hub-command-in-project-dir "issue create"))

(defun sjj-hub-show-issues ()
  (interactive)
  (sjj-hub-command-in-project-dir "issue"))

(provide 'git)
