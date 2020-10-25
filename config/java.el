(use-package lsp-java :ensure t)
(add-hook 'java-mode-hook #'lsp)

(use-package dap-mode :after lsp_mode :config (dap-auto-configure-mode) :ensure t)
(use-package dap-java :ensure nil)
