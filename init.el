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
;; macos setup DONE
;; resizing
;; recompile-init
;; command history DONE
;; projectile DONE
;; themes DONE
;; git change view in gutter thingy
;; git stuff ??
;; generic programming
;; Ctrl-W
;; helm(?) (NOT FOR NOW - trying ivy)
;; kill ring stuff
;; go
;; rust
;; markdown
;; refine magit setup

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

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
  :ensure t
  :bind (("M-t" . 'projectile-find-file))
  :init
  (setq projectile-switch-project-action 'projectile-vc)
  :bind-keymap
  ("s-p" . projectile-command-map)
  :config
  (projectile-mode +1))

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

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package smex
  :ensure t)

(defun swap-meta-and-super ()
  "Swap the mapping of Meta and Super.
Very useful for people using their Mac with a
Windows external keyboard from time to time."
  (interactive)
  (if (eq mac-command-modifier 'super)
      (progn
        (setq mac-command-modifier 'meta)
        (setq mac-option-modifier 'super)
        (message "Command is now bound to META and Option is bound to SUPER."))
    (setq mac-command-modifier 'super)
    (setq mac-option-modifier 'meta)
    (message "Command is now bound to SUPER and Option is bound to META.")))

(swap-meta-and-super)

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode +1))

(use-package discover-my-major
  :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package git-timemachine
  :ensure t)

(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))

(server-start)

(bind-key "C-x C-b" 'ibuffer)

(setq ibuffer-saved-filter-groups
    '(("home"
          ("Emacs-lisp" (or (filename . "\.el$")
                            (name . "\*scratch")))
          ("Clojure" (mode . clojure-mode))
          ("Ruby/Rails" (or (mode . ruby-mode)
                            (mode . haml-mode)
                            (mode . less-css-mode)))
          ("CSS" (or (mode . css-mode)
                     (mode . scss-mode)))
          (".NET" (mode . csharp-mode))
          ("HTML / HTML Templates" (mode . web-mode))
          ("Go" (mode . go-mode))
          ("Rust" (mode . rust-mode))
          ("Terminals" (mode . term-mode))
          ("Scripts" (mode . sh-mode))
          ("Inf As Code" (mode . terraform-mode))
          ("Build files" (or (mode . dockerfile-mode)
                             (mode . makefile-mode)
                             (mode . makefile-bsdmake-mode)))
          ("JS" (or (mode . js2-mode)
                    (mode . js-mode)
                    (mode . coffee-mode)))
          ("Docs" (or (mode . markdown-mode)
                      (mode . showoff-mode)
                      (mode . gfm-mode)))
          ("Configuration" (or (mode . json-mode)
                               (mode . conf-mode)
                               (mode . yaml-mode)
                               (mode . conf-unix-mode)))
          ("Code"  (filename . "code"))
          ("REPL" (or (mode . inferior-lisp-mode)
                      (mode . slime-repl-mode)))

          ("Shells" (or (mode . eshell-mode)))
          ("Magit" (name . "\*magit"))
          ("Org" (mode . org-mode))
          ("ERC" (mode . erc-mode))
          ("Dirs" (mode . dired-mode))
          ("Customize" (mode . Custom-mode))
          ("Help" (or (name . "\*Help\*")
                      (name . "\*Apropos\*")
                      (name . "\*info\*")))
          ("Scala" (mode . scala-mode))
          ("Man pages" (mode . Man-mode)))))

(add-hook 'ibuffer-mode-hook
    '(lambda ()
         (ibuffer-switch-to-saved-filter-groups "home")
         (ibuffer-auto-mode 1)))

(setq ibuffer-show-empty-filter-groups nil)
(add-to-list 'ibuffer-never-show-predicates "^\\*")

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
