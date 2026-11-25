;;; git.el  -*- lexical-binding: t; -*-
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
  :config
  (remove-hook 'magit-status-headers-hook 'magit-insert-tags-header))

(use-package git-timemachine
  :ensure t
  :defer t)

(use-package diff-hl
  :ensure t
  :defer 1
  :config
  (progn
    (global-diff-hl-mode +1)
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

(use-package github-browse-file
  :ensure t
  :defer t)

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

(defun sjj-bitbucket-push-and-create-pr ()
  "Push current branch using magit and open Bitbucket PR creation page."
  (interactive)
  (let ((branch (magit-get-current-branch)))
    (unless branch
      (user-error "No current branch"))
    ;; Perform the magit push to upstream
    (magit-push-current-to-upstream nil)
    ;; Add a hook to extract and open the URL after the push completes
    (add-hook 'magit-process-finish-hook
              #'sjj-bitbucket-extract-pr-url
              nil t)))

(defun sjj-bitbucket-extract-pr-url (process event)
  "Extract Bitbucket PR URL from magit process buffer and open it."
  (when (and (eq (process-status process) 'exit)
             (= (process-exit-status process) 0))
    (with-current-buffer (process-buffer process)
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward "https://bitbucket\\.org/[^[:space:]\n]+" nil t)
          (let ((url (match-string 0)))
            (browse-url url)
            (message "Opened PR creation page: %s" url)))))
    ;; Refresh the magit status buffer
    (magit-refresh)
    ;; Remove the hook after it runs once
    (remove-hook 'magit-process-finish-hook #'sjj-bitbucket-extract-pr-url t)))

(provide 'git)
