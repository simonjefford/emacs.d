(use-package markdown-mode
  :ensure t
  :config (setq-local flycheck-checkers '())
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md" . gfm-mode)
	 ("\\.markdown" . gfm-mode)))

(defun sjj-preview-markdown ()
  (interactive)
  (let ((command (concat "open -a \"Marked 2\" " buffer-file-name)))
    (shell-command command)))

(provide 'markdown-setup)
