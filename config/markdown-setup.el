(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md" . gfm-mode)
	 ("\\.markdown" . gfm-mode)))

(defun sjj-preview-markdown ()
  (interactive)
  (let ((command (concat "vmd " buffer-file-name)))
    (async-shell-command command)))

(provide 'markdown-setup)
