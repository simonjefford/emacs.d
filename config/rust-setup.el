(use-package rust-mode
  :ensure t)

(use-package flycheck-rust
  :ensure t
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(provide 'rust-setup)
