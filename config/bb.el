;;; bb.el --- Bitbucket PR management via bb CLI  -*- lexical-binding: t; -*-

(defvar bb-executable "bb"
  "Path to the bb CLI.")

(defun bb--project-dir ()
  (or (and (boundp 'bb--list-repo-dir) bb--list-repo-dir)
      (projectile-project-root)
      default-directory))

(defun bb--run (args)
  "Run bb with ARGS in the current project dir, return output string."
  (let ((default-directory (bb--project-dir)))
    (with-temp-buffer
      (let ((exit-code (apply #'call-process bb-executable nil t nil args)))
        (if (zerop exit-code)
            (buffer-string)
          (user-error "bb error: %s" (buffer-string)))))))

(defun bb--run-in-list-buf (args)
  "Run bb with ARGS using the list buffer's repo dir."
  (let ((dir (or bb--list-repo-dir (bb--project-dir))))
    (with-temp-buffer
      (let* ((default-directory dir)
             (exit-code (apply #'call-process bb-executable nil t nil args)))
        (if (zerop exit-code)
            (buffer-string)
          (user-error "bb error: %s" (buffer-string)))))))

(defun bb--run-async (args buf-name)
  "Run bb with ARGS in an async buffer named BUF-NAME."
  (let* ((default-directory (bb--project-dir))
         (buf (get-buffer-create buf-name)))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer))
    (apply #'start-process "bb" buf bb-executable args)
    (with-current-buffer buf
      (read-only-mode 1)
      (goto-char (point-min)))
    (display-buffer buf)))

(defun bb-create-pr-fill ()
  "Create a PR using commit messages for title and body (--fill)."
  (interactive)
  (let* ((default-directory (bb--project-dir))
         (result (bb--run '("pr" "create" "--fill"))))
    (message "%s" (string-trim result))))

(defun bb-create-pr-editor ()
  "Create a PR, opening the system editor for title and body."
  (interactive)
  (let* ((default-directory (bb--project-dir))
         (buf (get-buffer-create "*bb-create-pr*")))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer))
    ;; Run in a terminal since $EDITOR needs a tty
    (let ((proc (apply #'start-process "bb-create" buf
                       bb-executable '("pr" "create" "--editor"))))
      (set-process-sentinel
       proc
       (lambda (p _event)
         (when (eq (process-status p) 'exit)
           (with-current-buffer (process-buffer p)
             (message "%s" (string-trim (buffer-string))))))))
    (display-buffer buf)))

(defun bb-create-pr-web ()
  "Open browser to create a PR for the current branch."
  (interactive)
  (let* ((default-directory (bb--project-dir))
         (result (bb--run '("pr" "create" "--web"))))
    (message "%s" (string-trim result))))

(defun bb-create-pr (base)
  "Create a PR interactively. Reads title; opens $EDITOR for body.
With prefix arg, prompts for BASE branch (default: repo default)."
  (interactive
   (list (if current-prefix-arg
             (read-string "Base branch: " "main")
           nil)))
  (let* ((default-directory (bb--project-dir))
         (title (read-string "PR title: "))
         (args (append '("pr" "create")
                       (list "--title" title)
                       (when base (list "--base" base))
                       '("--editor"))))
    (when (string-empty-p title)
      (user-error "Aborted: no title"))
    ;; Need a real terminal for the editor; use async-shell-command as fallback
    (let ((cmd (mapconcat #'shell-quote-argument
                          (cons bb-executable args) " ")))
      (let ((buf (get-buffer-create "*bb-create-pr*")))
        (with-current-buffer buf (erase-buffer))
        (let ((proc (start-process-shell-command "bb-create" buf cmd)))
          (set-process-sentinel
           proc
           (lambda (p _event)
             (when (eq (process-status p) 'exit)
               (with-current-buffer (process-buffer p)
                 (message "%s" (string-trim (buffer-string))))))))
        (display-buffer buf)))))

(defun bb-list-prs ()
  "List open pull requests for the current project."
  (interactive)
  (bb--run-async-pr-list '("pr" "list") "*bb-prs*" (bb--project-dir)))

(defun bb-list-my-prs ()
  "List open pull requests authored by you for the current project."
  (interactive)
  (bb--run-async-pr-list '("pr" "list" "--mine") "*bb-my-prs*" (bb--project-dir)))

(defun bb-show-pr (id)
  "Show details of pull request ID."
  (interactive "sPR id: ")
  (bb--run-async (list "pr" "show" id) (format "*bb-pr-%s*" id)))

(defun bb-diff-pr (id)
  "Show diff of pull request ID in a diff-mode buffer."
  (interactive "sPR id: ")
  (let* ((default-directory (bb--project-dir))
         (buf (get-buffer-create (format "*bb-diff-%s*" id))))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer)
      (call-process bb-executable nil t nil "pr" "diff" id)
      (diff-mode)
      (read-only-mode 1)
      (goto-char (point-min)))
    (display-buffer buf)))

(defun bb-approve-pr (id)
  "Approve pull request ID."
  (interactive "sPR id: ")
  (message "%s" (string-trim (bb--run (list "pr" "approve" id)))))

(defun bb-request-changes-pr (id)
  "Request changes on pull request ID."
  (interactive "sPR id: ")
  (message "%s" (string-trim (bb--run (list "pr" "request-changes" id)))))

(defun bb-merge-pr (id)
  "Merge pull request ID (prompts for strategy)."
  (interactive "sPR id: ")
  (let ((strategy (completing-read "Merge strategy: "
                                   '("merge_commit" "squash" "fast_forward")
                                   nil t nil nil "merge_commit")))
    (message "%s" (string-trim (bb--run (list "pr" "merge" id "--strategy" strategy))))))

(defun bb-decline-pr (id)
  "Decline pull request ID."
  (interactive "sPR id: ")
  (when (yes-or-no-p (format "Decline PR #%s? " id))
    (message "%s" (string-trim (bb--run (list "pr" "decline" id))))))

(defun bb-pr-at-point ()
  "Get PR number from the current line (looks for #NNNN pattern)."
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward "#\\([0-9]+\\)" (line-end-position) t)
      (match-string 1))))

(defun bb-browse-pr-at-point ()
  "Open the Bitbucket PR URL for the PR number on the current line."
  (interactive)
  (let* ((id (or (bb-pr-at-point) (read-string "PR id: ")))
         (json-str (bb--run-in-list-buf (list "pr" "show" id "--json")))
         (data (json-read-from-string json-str))
         (url (alist-get 'href
                         (alist-get 'html
                                    (alist-get 'links data)))))
    (if url
        (browse-url url)
      (user-error "Could not find URL for PR #%s" id))))

(defun bb-show-pr-at-point ()
  "Show PR details for the PR number on the current line."
  (interactive)
  (let* ((id (or (bb-pr-at-point) (read-string "PR id: ")))
         (dir (or bb--list-repo-dir (bb--project-dir)))
         (buf (get-buffer-create (format "*bb-pr-%s*" id))))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer)
      (let ((default-directory dir))
        (call-process bb-executable nil t nil "pr" "show" id))
      (read-only-mode 1)
      (goto-char (point-min)))
    (display-buffer buf)))

(defun bb-diff-pr-at-point ()
  "Show diff for the PR number on the current line."
  (interactive)
  (let* ((id (or (bb-pr-at-point) (read-string "PR id: ")))
         (dir (or bb--list-repo-dir (bb--project-dir)))
         (buf (get-buffer-create (format "*bb-diff-%s*" id))))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer)
      (let ((default-directory dir))
        (call-process bb-executable nil t nil "pr" "diff" id))
      (diff-mode)
      (read-only-mode 1)
      (goto-char (point-min)))
    (display-buffer buf)))

(defun bb-approve-pr-at-point ()
  "Approve the PR number on the current line."
  (interactive)
  (let ((id (or (bb-pr-at-point) (read-string "PR id: "))))
    (message "%s" (string-trim (bb--run-in-list-buf (list "pr" "approve" id))))))

(defun bb-merge-pr-at-point ()
  "Merge the PR number on the current line."
  (interactive)
  (let ((id (or (bb-pr-at-point) (read-string "PR id: "))))
    (bb-merge-pr id)))

(defvar bb-pr-list-mode-map (make-sparse-keymap))
(set-keymap-parent bb-pr-list-mode-map special-mode-map)
(define-key bb-pr-list-mode-map (kbd "RET")   #'bb-show-pr-at-point)
(define-key bb-pr-list-mode-map (kbd "b")     #'bb-browse-pr-at-point)
(define-key bb-pr-list-mode-map (kbd "d")     #'bb-diff-pr-at-point)
(define-key bb-pr-list-mode-map (kbd "a")     #'bb-approve-pr-at-point)
(define-key bb-pr-list-mode-map (kbd "m")     #'bb-merge-pr-at-point)
(define-key bb-pr-list-mode-map (kbd "n")     #'next-line)
(define-key bb-pr-list-mode-map (kbd "p")     #'previous-line)

(define-derived-mode bb-pr-list-mode special-mode "BB-PRs"
  "Major mode for bb pull request list buffers.")

(defvar-local bb--list-repo-dir nil
  "Project directory for this bb PR list buffer.")

(defun bb--run-async-pr-list (args buf-name project-dir)
  "Run bb with ARGS, display results in BUF-NAME with pr-list keybindings."
  (let* ((default-directory project-dir)
         (buf (get-buffer-create buf-name)))
    (with-current-buffer buf
      (bb-pr-list-mode)
      (setq-local bb--list-repo-dir project-dir)
      (setq-local revert-buffer-function
                  (lambda (_ignore-auto _noconfirm)
                    (bb--run-async-pr-list args buf-name project-dir)))
      (let ((inhibit-read-only t))
        (erase-buffer)))
    (let ((proc (apply #'start-process "bb" buf bb-executable args)))
      (set-process-sentinel
       proc
       (lambda (p _event)
         (when (eq (process-status p) 'exit)
           (with-current-buffer (process-buffer p)
             (let ((inhibit-read-only t))
               (goto-char (point-max))
               (when (looking-back "\nProcess bb finished\n" nil)
                 (delete-region (match-beginning 0) (point-max))))
             (goto-char (point-min))
             (dolist (win (get-buffer-window-list (current-buffer) nil t))
               (set-window-point win (point-min)))))))
    (display-buffer buf))))

(bind-keys
 ("s-m p c" . bb-create-pr)
 ("s-m p C" . bb-create-pr-fill)
 ("s-m p W" . bb-create-pr-web)
 ("s-m p l" . bb-list-prs)
 ("s-m p L" . bb-list-my-prs)
 ("s-m p s" . bb-show-pr)
 ("s-m p d" . bb-diff-pr)
 ("s-m p a" . bb-approve-pr)
 ("s-m p r" . bb-request-changes-pr)
 ("s-m p m" . bb-merge-pr)
 ("s-m p D" . bb-decline-pr)
 ;; at-point variants (useful from the *bb-prs* list buffer)
 ("s-m p RET" . bb-show-pr-at-point)
 ("s-m p TAB" . bb-diff-pr-at-point)
 ("s-m p A"   . bb-approve-pr-at-point)
 ("s-m p M"   . bb-merge-pr-at-point))

(with-eval-after-load 'magit
  (transient-define-prefix bb-magit-transient ()
    "Bitbucket PR commands."
    ["Bitbucket PR"
     ("c" "Create PR (editor)"  bb-create-pr)
     ("f" "Create PR (--fill)"  bb-create-pr-fill)
     ("w" "Create PR (web)"     bb-create-pr-web)
     ("l" "List PRs"            bb-list-prs)
     ("L" "List my PRs"         bb-list-my-prs)])
  (define-key magit-status-mode-map (kbd "C-c p") #'bb-magit-transient))

(provide 'bb)
