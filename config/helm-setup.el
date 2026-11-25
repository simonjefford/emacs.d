;;; helm-setup.el  -*- lexical-binding: t; -*-
(use-package helm
  :ensure t
  ;; Load a second after startup (or immediately on any key below) rather
  ;; than during init; helm-files pulls in tramp.
  :defer 1
  :diminish helm-mode
  :bind (("M-x" . 'helm-M-x)
	 ("C-x C-m" . 'helm-M-x)
	 ("M-y" . 'helm-show-kill-ring)
	 ("C-x b" . 'helm-mini)
	 ("C-x C-f" . 'helm-find-files)
	 ("C-h f" . 'helm-apropos)
	 ("C-h r" . 'helm-info-emacs)
	 ("C-h C-l" . 'helm-locate-library)
	 ("C-c h" . 'helm-command-prefix))
  :init (progn
	  (setq helm-split-window-inside-p            t
		helm-buffers-fuzzy-matching           t
		helm-move-to-line-cycle-in-source     t
		helm-ff-search-library-in-sexp        t
		history-delete-duplicates             t
		history-length                        200
		helm-ff-file-name-history-use-recentf t))
  :config (helm-mode 1)
  :bind (:map helm-command-map
	      ("o" . 'helm-occur)))

;;(bind-key "s-p s s" 'helm-projectile-rg)

(use-package helm-projectile
  :ensure t
  :after (helm projectile)
  :config (progn
	    (helm-projectile-on)))

;; vendored without an autoloads file
(use-package helm-ag
  :commands (helm-ag helm-do-ag helm-ag-this-file helm-do-ag-this-file
             helm-ag-project-root helm-do-ag-project-root
             helm-ag-buffers helm-do-ag-buffers
             helm-ag-pop-stack helm-ag-clear-stack))

(use-package helm-descbinds
  :ensure t
  :defer t)

;; Helm's own faces hard-code colours meant for light themes (dark red on
;; light grey directories, gold matches, a green selection bar). Themes that
;; don't style helm, like batppuccin, end up with those. Redefine them to
;; inherit standard faces every theme styles. These become the faces'
;; *default* specs, so a theme that does style helm still wins.
(defvar sjj-helm-face-specs
  '((helm-source-header        :inherit header-line :weight bold :extend t)
    (helm-selection            :inherit region :extend t)
    (helm-match                :inherit match)
    (helm-candidate-number     :inherit (bold mode-line-emphasis))
    (helm-visible-mark         :inherit secondary-selection :extend t)
    (helm-separator            :inherit shadow)
    (helm-header-line-left-margin :inherit (warning header-line))
    (helm-M-x-short-doc        :inherit shadow)
    (helm-prefarg              :inherit warning)
    (helm-tooltip              :inherit tooltip)
    (helm-resume-need-update   :inherit error)
    (helm-mode-prefix          :inherit warning)
    (helm-delete-async-message :inherit warning)
    (helm-history-remote       :inherit warning)
    (helm-indirect-buffer      :inherit shadow)
    ;; files
    (helm-ff-directory         :inherit dired-directory :extend t)
    (helm-ff-dotted-directory  :inherit (shadow dired-directory) :extend t)
    (helm-ff-dotted-symlink-directory :inherit (shadow dired-symlink) :extend t)
    (helm-ff-executable        :inherit success :extend t)
    (helm-ff-file-extension    :inherit font-lock-type-face :extend t)
    (helm-ff-invalid-symlink   :inherit error :extend t)
    (helm-ff-denied            :inherit error :extend t)
    (helm-ff-prefix            :inherit (bold warning) :extend t)
    (helm-ff-pipe              :inherit warning :extend t)
    (helm-ff-socket            :inherit warning :extend t)
    (helm-ff-suid              :inherit error :extend t)
    (helm-ff-backup-file       :inherit shadow :extend t)
    ;; buffers
    (helm-buffer-directory     :inherit dired-directory :extend t)
    (helm-buffer-not-saved     :inherit warning :extend t)
    (helm-buffer-saved-out     :inherit error :extend t)
    (helm-buffer-process       :inherit font-lock-builtin-face :extend t)
    (helm-buffer-size          :inherit shadow :extend t)
    (helm-buffer-archive       :inherit font-lock-constant-face :extend t)
    (helm-buffer-renamed-out   :inherit success :extend t)
    (helm-no-file-buffer-modified :inherit warning :extend t)
    ;; grep / occur / locate / elisp
    (helm-grep-file            :inherit compilation-info :extend t)
    (helm-grep-lineno          :inherit compilation-line-number :extend t)
    (helm-grep-match           :inherit match :extend t)
    (helm-grep-finish          :inherit success :extend t)
    (helm-moccur-buffer        :inherit compilation-info :extend t)
    (helm-etags-file           :inherit compilation-info :extend t)
    (helm-locate-finish        :inherit success :extend t)
    (helm-lisp-completion-info :inherit font-lock-comment-face :extend t)
    (helm-lisp-show-completion :inherit highlight :extend t)))

(defun sjj-helm-apply-face-specs (&rest _)
  "Make helm's hard-coded faces inherit standard ones (see above)."
  (pcase-dolist (`(,face . ,attrs) sjj-helm-face-specs)
    (when (facep face)
      (face-spec-set face `((t ,@attrs)) 'face-defface-spec))))

;; Helm's faces are spread over many libraries that load on demand, and
;; loading one resets its faces' defaults, so re-apply after each.
(add-hook 'after-load-functions
          (lambda (file)
            (when (string-prefix-p "helm" (file-name-nondirectory file))
              (sjj-helm-apply-face-specs))))

(provide 'helm-setup)
