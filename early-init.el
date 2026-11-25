;;; early-init.el  -*- lexical-binding: t; -*-
;; Runs before package activation and before the first frame is drawn.

;; Don't garbage-collect during startup; settle on a sane threshold afterwards.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Skip file-name-handler lookups (tramp, jka-compr, ...) for every file
;; loaded during startup.
(defvar sjj--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       sjj--file-name-handler-alist)))))

;; Activate packages from one pre-concatenated autoloads file instead of
;; loading ~140 separate ones. package.el regenerates it on install/delete;
;; run M-x package-quickstart-refresh after changing packages any other way.
(setq package-quickstart t)

;; Turn chrome off before the first frame exists, rather than drawing it and
;; then resizing.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq frame-inhibit-implied-resize t)

;; More throughput from subprocesses (lsp, magit).
(setq read-process-output-max (* 1024 1024))
