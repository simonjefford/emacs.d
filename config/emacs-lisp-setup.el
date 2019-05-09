(defun emacs-lisp-defaults()
  (progn
    (smartparens-strict-mode +1)
    (eldoc-mode +1)
    (setq-local flycheck-checkers '())
    (whitespace-mode -1)))

(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-defaults)

(provide 'emacs-lisp-setup)
