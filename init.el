;; MELPA setup
(require 'package)

(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/"))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; TODO
;; C-x m DONE with IVY
;; custom stuff into a separate file
;; backup files into a sane place
;; recentf in C-x b DONE (ivy)
;; C-x b setup DONE (ivy)
;; magit DONE
;; macos setup
;; projectile
;; themes
;; git change view in gutter thingy
;; git stuff
;; generic programming
;; Ctrl-W
;; helm(?) (NOT FOR NOW - trying ivy)
;; kill ring stuff
;; go
;; rust
;; markdown

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(menu-bar-mode -1)

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

(load-theme 'deeper-blue)

(use-package magit
  :ensure t)

(use-package projectile
  :ensure t)

(use-package crux
  :ensure t)

(use-package counsel
  :ensure t)

(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t)
  :bind (("C-x C-m" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-x b" . ivy-switch-buffer))
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (magit use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
