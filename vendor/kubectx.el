;;; kubectx.el  -*- lexical-binding: t; -*-
;; Show the current kubectl context and namespace in the mode line.
;; kubectl runs asynchronously, so updates never block Emacs.

(defvar kubectx-kubectl-command "kubectl")
(defvar kubectx-timer nil)
(defvar kubectx-string "")
(defvar kubectx-update-interval 10)
(defvar kubectx--process nil
  "The kubectl process for an update in flight, if any.")

(defun kubectx--kill-buffer-and-process (buf)
  "Kill BUF and any process attached to it, without prompting."
  (when (buffer-live-p buf)
    (let ((proc (get-buffer-process buf)))
      (when proc
        (set-process-query-on-exit-flag proc nil)
        (delete-process proc)))
    (kill-buffer buf)))

(defun kubectx--sentinel (proc _event)
  "Set `kubectx-string' from PROC's output once it has exited."
  (unless (process-live-p proc)
    (let ((buf (process-buffer proc)))
      (setq kubectx-string
            (concat " "
                    (if (and (eq (process-status proc) 'exit)
                             (= (process-exit-status proc) 0)
                             (buffer-live-p buf))
                        (with-current-buffer buf
                          (string-trim (buffer-string)))
                      "n/a")))
      (when (eq proc kubectx--process)
        (setq kubectx--process nil))
      (kubectx--kill-buffer-and-process buf)
      (kubectx--kill-buffer-and-process (process-get proc 'kubectx-stderr))
      (force-mode-line-update t))))

(defun kubectx-update ()
  "Update `kubectx-string' with the current context and namespace.
Starts kubectl in the background and returns immediately; does nothing
if an update is already running."
  (interactive)
  (cond
   ((process-live-p kubectx--process))
   ((not (executable-find kubectx-kubectl-command))
    (setq kubectx-string " n/a"))
   (t
    (let ((stderr (generate-new-buffer " *kubectx-stderr*")))
      (setq kubectx--process
            (make-process
             :name "kubectx"
             :buffer (generate-new-buffer " *kubectx*")
             ;; One call for both: "<context> <namespace>"
             :command (list kubectx-kubectl-command
                            "config" "view" "--minify" "--output"
                            "jsonpath={.current-context} {..namespace}")
             :connection-type 'pipe
             :noquery t
             ;; keep kubectl warnings out of the result
             :stderr stderr
             :sentinel #'kubectx--sentinel))
      (process-put kubectx--process 'kubectx-stderr stderr)))))

(define-minor-mode kubectx-mode
  "Add kubectx and namespace info to the mode line"
  :global t
  :group 'mode-line
  (when (not global-mode-string) (setq global-mode-string '("")))
  (when kubectx-timer (cancel-timer kubectx-timer))
  (if (not kubectx-mode)
      (setq global-mode-string
            (delq 'kubectx-string global-mode-string))
    (add-to-list 'global-mode-string 'kubectx-string t)
    (if (> kubectx-update-interval 0)
        (setq kubectx-timer
              (run-at-time nil kubectx-update-interval
                           'kubectx-update))
      (kubectx-update))))

(provide 'kubectx)
