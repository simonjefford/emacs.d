(use-package rust-mode
  :hook (rust-mode-hook . lsp-deferred)
  :ensure t)

(use-package flycheck-rust
  :ensure t
  :hook (flycheck-mode-hook . flycheck-rust-setup))

(setq rust-format-on-save t)

(provide 'rust-setup)
