;;; json-to-hcl-iam-policy.el --- Convert JSON IAM policies to HCL format -*- lexical-binding: t; -*-

;; Author: Claude
;; Version: 1.0
;; Package-Requires: ((emacs "27.1"))

;;; Commentary:
;; Converts AWS IAM policy JSON from kill-ring to Terraform HCL aws_iam_policy_document format

;;; Code:

(require 'json)

(defun json-to-hcl-iam-policy--format-list (items indent)
  "Format a list of ITEMS with proper INDENT for HCL."
  (if (= (length items) 1)
      (format "[\n%s\"%s\",\n%s]"
              (make-string (+ indent 2) ?\s)
              (car items)
              (make-string indent ?\s))
    (concat "[\n"
            (mapconcat (lambda (item)
                         (format "%s\"%s\","
                                 (make-string (+ indent 2) ?\s)
                                 item))
                       items
                       "\n")
            "\n"
            (make-string indent ?\s)
            "]")))

(defun json-to-hcl-iam-policy--format-condition (condition indent)
  "Format a CONDITION block with INDENT for HCL."
  (let ((result ""))
    (dolist (test-var (map-keys condition))
      (let* ((test-key (symbol-name test-var))
             (variables (map-elt condition test-var))
             (indent-str (make-string indent ?\s)))
        (dolist (var-key (map-keys variables))
          (let* ((variable (symbol-name var-key))
                 (values (map-elt variables var-key))
                 (values-list (if (vectorp values) (append values nil)
                               (if (listp values) values (list values)))))
            (setq result
                  (concat result
                          (format "\n%scondition {\n" indent-str)
                          (format "%s  test     = \"%s\"\n" indent-str test-key)
                          (format "%s  variable = \"%s\"\n" indent-str variable)
                          (format "%s  values = %s\n"
                                  indent-str
                                  (json-to-hcl-iam-policy--format-list
                                   (mapcar (lambda (v) (format "%s" v)) values-list)
                                   (+ indent 11)))
                          (format "%s}\n" indent-str)))))))
    result))

(defun json-to-hcl-iam-policy--format-statement (statement)
  "Format a single STATEMENT as HCL."
  (let* ((effect (map-elt statement 'Effect))
         (actions-raw (map-elt statement 'Action))
         (actions (if (vectorp actions-raw)
                      (append actions-raw nil)
                    (list actions-raw)))
         (resources-raw (map-elt statement 'Resource))
         (resources (if (vectorp resources-raw)
                        (append resources-raw nil)
                      (list resources-raw)))
         (condition (map-elt statement 'Condition))
         (result ""))

    (setq result (concat result "  statement {\n"))
    (setq result (concat result (format "    effect = \"%s\"\n" effect)))
    (setq result (concat result (format "    actions = %s\n"
                                        (json-to-hcl-iam-policy--format-list actions 15))))
    (setq result (concat result (format "    resources = %s\n"
                                        (json-to-hcl-iam-policy--format-list resources 17))))

    (when condition
      (setq result (concat result (json-to-hcl-iam-policy--format-condition condition 4))))

    (setq result (concat result "  }\n"))
    result))

(defun json-to-hcl-iam-policy--convert (json-string policy-name)
  "Convert JSON-STRING IAM policy to HCL format with POLICY-NAME."
  (let* ((policy (json-parse-string json-string :object-type 'alist :array-type 'vector))
         (statements (map-elt policy 'Statement))
         (statements-list (append statements nil))
         (result ""))

    (setq result (concat result (format "data \"aws_iam_policy_document\" \"%s\" {\n" policy-name)))

    (dolist (statement statements-list)
      (setq result (concat result (json-to-hcl-iam-policy--format-statement statement))))

    (setq result (concat result "}\n"))
    result))

;;;###autoload
(defun json-to-hcl-iam-policy-from-kill-ring (policy-name)
  "Convert JSON IAM policy from kill-ring to HCL aws_iam_policy_document format.
Prompts for POLICY-NAME to use in the data source declaration.
Inserts the result at point or copies to kill-ring if called with prefix arg."
  (interactive "sPolicy name: ")
  (let* ((json-string (current-kill 0 t))
         (hcl-output (condition-case err
                         (json-to-hcl-iam-policy--convert json-string policy-name)
                       (error (format "Error parsing JSON: %s" (error-message-string err))))))
    (if (string-prefix-p "Error" hcl-output)
        (message "%s" hcl-output)
      (if current-prefix-arg
          (progn
            (kill-new hcl-output)
            (message "HCL policy copied to kill-ring"))
        (insert hcl-output)
        (message "HCL policy inserted at point")))))

(provide 'json-to-hcl-iam-policy)
;;; json-to-hcl-iam-policy.el ends here
