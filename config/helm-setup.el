;;; helm-setup.el  -*- lexical-binding: t; -*-
(use-package helm
  :ensure t
  :demand t
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
  :config (progn
	    (helm-projectile-on)))

(require 'helm-ag)

(use-package helm-descbinds
  :ensure t)

(provide 'helm-setup)
