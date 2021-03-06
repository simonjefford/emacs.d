(use-package org-projectile
  :bind (("C-c n p" . org-projectile-project-todo-completing-read)
         ("C-c c" . org-capture))
  :config
  (progn
    (setq org-projectile-projects-file
          "/Users/sjefford/.emacs.d/projects.org")
    (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
    (push (org-projectile-project-todo-entry) org-capture-templates))
  :ensure t)

;; TODO - how to get this to work?
;; (add-hook 'org-mode-hook (lambda ()
;; 			   (add-to-list 'org-latex-classes
;; 					'("koma-article"
;; 					  "\\documentclass{scrartcl}"
;; 					  ("\\section{%s}" . "\\section*{%s}")
;; 					  ("\\subsection{%s}" . "\\subsection*{%s}")
;; 					  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;; 					  ("\\paragraph{%s}" . "\\paragraph*{%s}")
;; 					  ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))))

(defvar sjj-ideas-org-file "~/Documents/ideas.org")

(defun sjj-open-ideas()
  (interactive)
  (find-file sjj-ideas-org-file))

(bind-key "C-c i" 'sjj-open-ideas)

(provide 'org-setup)
