;;; copilot-setup.el  -*- lexical-binding: t; -*-
(use-package copilot
  :quelpa (copilot :fetcher github
                   :repo "zerolfx/copilot.el"
                   :branch "main"
                   :files ("dist" "*.el")))
(provide 'copilot-setup)
