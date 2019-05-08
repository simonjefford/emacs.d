(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(provide 'package-setup)
