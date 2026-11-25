;;; ruby-setup.el  -*- lexical-binding: t; -*-
(use-package inf-ruby
  :ensure t
  :defer t)

(use-package rspec-mode :ensure t :defer t)

(put 'rspec-rake-command 'safe-local-variable #'stringp)

(provide 'ruby-setup)
