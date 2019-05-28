(defvar kubectx-kubectl-command "kubectl")
(defvar kubectx-timer nil)
(defvar kubectx-string "")
(defvar kubectx-update-interval 10)

(defun kubectx-run-kubectl (&rest args)
  "Run kubectl command"
  (with-temp-buffer
    (if (and (executable-find kubectx-kubectl-command)
             (= (apply 'call-process kubectx-kubectl-command nil t nil args) 0))
        (replace-regexp-in-string "\n\\'" "" (buffer-string))
      "n/a")))

(defun kubectx-update ()
  "Update kubectx mode-line string with current context and namespace"
  (interactive)
  (let ((ctx (kubectx-run-kubectl "config" "current-context"))
        (ns (kubectx-run-kubectl "config" "view" "--minify" "--output" "jsonpath={..namespace}")))
    (setq kubectx-string (concat " " ctx " " ns))))

(define-minor-mode kubectx-mode
  "Add kubectx and namespace info to the mode line"
  :global t
  (when (not global-mode-string) (setq global-mode-string '("")))
  (when kubectx-timer (cancel-timer kubectx-timer))
  (if (not kubectx-mode)
      (setq global-mode-string
            (delq 'kubectx-string global-mode-string))
    (add-to-list 'global-mode-string 'kubectx-string t)
    (when (> kubectx-update-interval 0)
      (setq kubectx-timer
            (run-at-time nil kubectx-update-interval
                         'kubectx-update)))
    (kubectx-update)))

(provide 'kubectx)
