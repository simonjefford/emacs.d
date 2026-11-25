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

(provide 'helm-setup)
