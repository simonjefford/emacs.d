;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; autosave the undo-tree history
(setq undo-tree-history-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq undo-tree-auto-save-history t)

(use-package crux
  :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

(use-package smartparens
  :ensure t
  :init
  (progn
    (setq sp-base-key-bindings 'paredit)
    (setq sp-autoskil-closing-pair 'always)
    (setq sp-hybrid-kill-entire-symbol nil))
  :config
  (progn
    (require 'smartparens-config)
    (sp-use-paredit-bindings)
    (show-smartparens-global-mode +1)))

(use-package browse-kill-ring
  :bind (("s-y" . browse-kill-ring))
  :ensure t)

(winner-mode +1)

(provide 'general-editor-setup)
