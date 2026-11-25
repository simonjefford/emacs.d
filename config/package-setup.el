;;; package-setup.el  -*- lexical-binding: t; -*-
;; Packages are already activated by startup (see early-init.el), so don't
;; call package-initialize again: it also parses the whole MELPA archive
;; index on every start. use-package's :ensure refreshes archives itself
;; when it needs to install something, and use-package is built in.
(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/"))

(provide 'package-setup)
