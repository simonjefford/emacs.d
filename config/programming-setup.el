;;; programming-setup.el  -*- lexical-binding: t; -*-
(defun sjj-lsp-dedupe-diagnostics (params _workspace)
  "Merge diagnostics in PARAMS that share a range, code and message.
gopls can publish the same compiler error twice, once with the
\"unnecessary\" tag and once without, so flycheck lists it twice. Keep the
tagged copy: it carries the faded face and gopls's quick fix."
  (let ((seen (make-hash-table :test 'equal))
        (order nil))
    (seq-doseq (diag (lsp-get params :diagnostics))
      (let* ((range (lsp-get diag :range))
             (start (lsp-get range :start))
             (end (lsp-get range :end))
             (key (list (lsp-get start :line) (lsp-get start :character)
                        (lsp-get end :line) (lsp-get end :character)
                        (lsp-get diag :code) (lsp-get diag :message)))
             (prev (gethash key seen)))
        (cond ((not prev)
               (puthash key diag seen)
               (push key order))
              ((and (lsp-get diag :tags) (not (lsp-get prev :tags)))
               (puthash key diag seen)))))
    (lsp-put params :diagnostics
             (vconcat (mapcar (lambda (key) (gethash key seen)) (nreverse order))))
    params))

(use-package lsp-mode
  :init
  (progn
    (setq lsp-prefer-flymake nil)
    (setq lsp-session-file (expand-file-name "lsp-session-v1" sjj-savefile-dir))
    (setq lsp-signature-render-documentation nil)
    (setq lsp-signature-doc-lines 0)
    (setq lsp-signature-auto-activate nil)
    (setq lsp-auto-guess-root 't)
    (setq lsp-diagnostic-filter #'sjj-lsp-dedupe-diagnostics))
  :commands (lsp lsp-deferred)
  :ensure t)

(use-package lsp-ui
  :init
  (progn
    (setq lsp-ui-sideline-enable nil))
  :ensure t
  :commands lsp-ui-mode)

(use-package typescript-mode
  :ensure t
  :defer t)

;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp)

(use-package flycheck
  :ensure t
  :defer 1
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
  :ensure t
  :defer t)

(use-package yaml-mode
  :ensure t
  :defer t)

(use-package protobuf-mode
  :ensure t
  :defer t)

(use-package dockerfile-mode
  :ensure t
  :defer t)

(use-package yasnippet
  :ensure t
  :defer 1
  :config (yas-global-mode))

(use-package gist
  :ensure t
  :defer t)

(use-package powershell :ensure t :defer t)

;; evilnc-default-hotkeys stopped working and M-; is the only shortcut
;; I ever use anyway
(use-package evil-nerd-commenter
  :ensure t
  :bind ("M-;" . evilnc-comment-or-uncomment-lines))

(use-package web-mode :ensure t :defer t)

(use-package jsonnet-mode :ensure t :defer t)

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

(use-package coffee-mode :ensure t :defer t)

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

(use-package dash-docs
  :ensure t
  :defer t)

(use-package bazel
  :ensure t
  :defer t)

(provide 'programming-setup)
