;; MELPA setup
(require 'package)

(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/"))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; TODO
;; custom stuff into a separate file
;; backup files into a sane place
;; recentf in C-x b
;; C-x b setup
;; magit
;; macos setup
;; projectile
;; themes
;; git change view in gutter thingy
;; git stuff
;; generic programming
;; Ctrl-W
;; helm(?)
;; kill ring stuff
;; go
;; rust
;; markdown

(use-package magit
  :ensure t)

(use-package projectile
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
