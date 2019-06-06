(defface slide-heading-face
  '((t (:inherit font-lock-function-name-face :height 1.5)))
  "Face for slide headers")

(defface slide-code-face
  '((t (:inherit fixed-pitch)))
  "Face for inline code, pre blocks, and fenced code blocks.
This may be used, for example, to add a contrasting background to
inline code fragments and code blocks.")

(defface slide-notes-face
  '((t (:inherit italic)))
  "Face for slide notes")

(setq slides-highlights
      '(("\\.image" . font-lock-function-name-face)
	("^  .*$" . 'slide-code-face)
	("^#.*$" . font-lock-comment-face)
	("^:.*$" . 'slide-notes-face)
	("^\\*.*$" . 'slide-heading-face)))

(add-to-list 'auto-mode-alist '("\\.slide\\'" . slides-mode))

(define-derived-mode slides-mode fundamental-mode "slides"
  "major mode for editing golang present style slides"
  (setq-local comment-start "#")
  (setq font-lock-defaults '(slides-highlights)))

(provide 'slides-mode)
