(use-package inf-ruby
  :ensure t)

(use-package rspec-mode :ensure t)

(use-package rbenv
  :ensure t
  :config
  (progn
    (global-rbenv-mode)))

(put 'rspec-rake-command 'safe-local-variable #'stringp)

(provide 'ruby-setup)
