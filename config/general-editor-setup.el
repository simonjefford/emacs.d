;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; autosave the undo-tree history
(setq undo-tree-history-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq undo-tree-auto-save-history t)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

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
  :config
  (browse-kill-ring-default-keybindings)
  :ensure t)

(winner-mode +1)

(defvar sjj-savefile-dir (expand-file-name "savefile" emacsd)
  "This folder stores all the automatically generated save/history-files.")

(unless (file-exists-p sjj-savefile-dir)
  (make-directory sjj-savefile-dir))

(setq save-place-file (expand-file-name "saveplace" sjj-savefile-dir))
(save-place-mode 1)

(require 'savehist)
(setq savehist-additional-variables
      ;; search entries
      '(search-ring regexp-search-ring)
      ;; save every minute
      savehist-autosave-interval 60
      ;; keep the home clean
      savehist-file (expand-file-name "savehist" sjj-savefile-dir))
(savehist-mode +1)

(require 'recentf)
(setq recentf-save-file (expand-file-name "recentf" sjj-savefile-dir)
      recentf-max-saved-items 500
      recentf-max-menu-items 15
      ;; disable recentf-cleanup on Emacs start, because it can cause
      ;; problems with remote files
      recentf-auto-cleanup 'never)

(defun sjj-recentf-exclude-p (file)
  "A predicate to decide whether to exclude FILE from recentf."
  (let ((file-dir (file-truename (file-name-directory file))))
    (cl-some (lambda (dir)
               (string-prefix-p dir file-dir))
             (mapcar 'file-truename (list sjj-savefile-dir package-user-dir)))))

(add-to-list 'recentf-exclude 'sjj-recentf-exclude-p)

;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings)
(provide 'general-editor-setup)

(defun save-if-appropriate()
  (when (and buffer-file-name
	     (buffer-modified-p (current-buffer))
	     (file-writable-p buffer-file-name))
    (save-buffer)))

(defmacro advise-commands (advice-name commands class &rest body)
  "Apply advice named ADVICE-NAME to multiple COMMANDS.

The body of the advice is in BODY."
  `(progn
     ,@(mapcar (lambda (command)
                 `(defadvice ,command (,class ,(intern (concat (symbol-name command) "-" advice-name)) activate)
                    ,@body))
               commands)))

(advise-commands "auto-save"
                 (switch-to-buffer other-window windmove-up windmove-down windmove-left windmove-right)
                 before
                 (save-if-appropriate))

(add-hook 'focus-out-hook 'save-if-appropriate)

(bind-key "s->" (lambda()
		    (interactive)
		    (enlarge-window 1)))

(bind-key "s-<" (lambda()
		    (interactive)
		    (shrink-window 1)))

(bind-key "C-s->" (lambda()
		    (interactive)
		    (enlarge-window-horizontally 1)))

(bind-key "C-s-<" (lambda()
		    (interactive)
		    (shrink,-window-horizontally 1)))

(bind-key "C-w" 'backward-kill-word)

(bind-key "M-`" 'other-frame)
