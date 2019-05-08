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

(provide 'ibuffer-setup)