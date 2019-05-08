(defvar emacsd (file-name-directory load-file-name))
(defvar main-config-dir (expand-file-name "config" emacsd))

(add-to-list 'load-path main-config-dir)

(require 'package-setup)
(require 'ui)
(require 'macos)
(require 'git)
(require 'ivy-setup)
(require 'projectile-setup)

(use-package crux
  :ensure t)

(use-package discover-my-major
  :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package rust-mode
  :ensure t)

(use-package browse-kill-ring
  :bind (("s-y" . browse-kill-ring))
  :ensure t)

(use-package go-mode
  :config
  (progn
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save))
  :ensure t)

(use-package go-guru
  :bind (:map go-mode-map
	      ("M-." . go-guru-definition))
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

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
(bind-key "C-w" 'backward-kill-word)

(bind-key "M-`" 'other-frame)

(use-package xkcd
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md" . gfm-mode)
	 ("\\.markdown" . gfm-mode)))

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

(defun emacs-lisp-setup()
  (progn
    (smartparens-strict-mode +1)
    (eldoc-mode +1)
    (whitespace-mode -1)))

(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-setup)

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(winner-mode +1)
