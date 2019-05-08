(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(defun swap-meta-and-super ()
  (interactive)
  (if (eq mac-command-modifier 'super)
      (progn
        (setq mac-command-modifier 'meta)
        (setq mac-option-modifier 'super)
        (message "Command is now bound to META and Option is bound to SUPER."))
    (setq mac-command-modifier 'super)
    (setq mac-option-modifier 'meta)
    (message "Command is now bound to SUPER and Option is bound to META.")))
(swap-meta-and-super)

(provide 'macos)