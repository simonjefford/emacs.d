(use-package lsp-mode
  :init
  (progn
    (setq lsp-prefer-flymake nil)
    (setq lsp-session-file (expand-file-name "lsp-session-v1" sjj-savefile-dir))
    (setq lsp-signature-render-documentation nil)
    (setq lsp-signature-doc-lines 0)
    (setq lsp-signature-auto-activate nil)
    (setq lsp-auto-guess-root 't))
  :commands (lsp lsp-deferred)
  :ensure t)

(use-package lsp-ui
  :init
  (progn
    (setq lsp-ui-sideline-enable nil))
  :ensure t
  :commands lsp-ui-mode)

(use-package typescript-mode
  :ensure t)

;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp)

(use-package flycheck
  :ensure t
  :config
  (progn
    (setq flycheck-checkers '(css-csslint
			      css-stylelint
			      dockerfile-hadolint
			      emacs-lisp
			      emacs-lisp-checkdoc
			      go-gofmt
			      go-golint
			      go-vet
			      go-build
			      go-test
			      go-unconvert
			      groovy
			      html-tidy
			      javascript-eslint
			      javascript-jshint
			      javascript-standard
			      json-jsonlint
			      json-python-json
			      json-jq
			      jsonnet
                              protobuf-protoc
			      protobuf-prototool
			      puppet-parser
			      puppet-lint
			      rpm-rpmlint
			      ruby-rubocop
			      ruby-reek
			      ruby-rubylint
			      ruby
			      ruby-jruby
			      rust-cargo
			      rust
			      rust-clippy
			      sh-posix-bash
			      sh-zsh
			      sh-shellcheck
			      terraform
			      terraform-tflint
			      typescript-tslint
			      xml-xmlstarlet
			      xml-xmllint
			      yaml-jsyaml
			      yaml-ruby))
    (global-flycheck-mode +1)))

;; "incidental" language setup
(use-package groovy-mode
  :init (add-to-list 'auto-mode-alist '("Jenkinsfile\\'" . groovy-mode))
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package protobuf-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(use-package yasnippet
  :ensure t
  :config (yas-global-mode))

(use-package gist
  :ensure t)

(use-package powershell :ensure t)

;; evilnc-default-hotkeys stopped working and M-; is the only shortcut
;; I ever use anyway
(use-package evil-nerd-commenter
  :ensure t
  :config (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines))

(use-package web-mode :ensure t)

(use-package jsonnet-mode :ensure t)

(setq compilation-ask-about-save nil)

(sp-pair "{" nil :post-handlers
         '(((lambda (&rest _ignored)
              (crux-smart-open-line-above)) "RET")))

(defun sjj-prog-mode-defaults()
  (set (make-local-variable 'comment-auto-fill-only-comments) t)
  (setq flyspell-prog-text-faces '(font-lock-command-face font-lock-doc-face))
  (flyspell-prog-mode)
  (smartparens-mode +1))

(add-hook 'prog-mode-hook 'sjj-prog-mode-defaults)

(setq projectile-project-compilation-cmd "")

(require 'kubectx)
(kubectx-mode 1)

(use-package coffee-mode :ensure t)

(defun sjj-visit-powershell-buffer ()
  (interactive)
  (crux-start-or-switch-to (lambda()
			     (ansi-term "/usr/local/bin/pwsh" "powershell"))
			   "*powershell*"))

(bind-key "C-c s" 'sjj-visit-powershell-buffer)

;; Ansi colours in compilation buffers
(require 'ansi-color)
(defun sjj-colorize-compilation ()
  "Colorize from `compilation-filter-start' to `point'."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region
     compilation-filter-start (point))))

(add-hook 'compilation-filter-hook
          #'sjj-colorize-compilation)

(setq git-link-open-in-browser 't)

(provide 'programming-setup)
