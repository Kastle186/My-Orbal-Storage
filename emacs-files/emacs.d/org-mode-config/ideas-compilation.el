;; *****************
;; Ideas Compilation
;; *****************

;; This file is only for keeping ideas I get that end up either leaving pending,
;; discarding, or simple inspiration of the moment.

;; *****************************************
;; Org-Mode Code Block Skeleton With Prompts
;; *****************************************

(define-skeleton org-code-block-template
  "Prompt for the characteristics of an org-mode code block, and generate the template
afterwards ready to add the code to it."
  ""
  (setq code-block-template "")
  (let ((block-name (read-string "Enter the code block's name (if any): "))
        (block-language (read-string "Enter the code block's language: "))
        (block-output-type (read-string "Enter the results' format (if any): "))
        (block-vars '())
        (more-vars (y-or-n-p "Will this code block receive variables? ")))

    ;; #+NAME:
    (unless (equal block-name "")
      (setq code-block-template (concat code-block-template
                                        (format "#+NAME: %s\n" block-name))))

    (while more-vars
      (let ((var-name (read-string "Enter the variable's name: "))
            (var-value (read-string "Enter the variable's value: ")))
        (add-to-list 'block-vars (format "%s=%s" var-name var-value) t))

      (setq more-vars (y-or-n-p "Add more variables? ")))

    ;; #+HEADER:
    (unless (equal block-vars '())
      (setq code-block-template
            (concat code-block-template
                    (format "#+HEADER: :var%s\n" (cl-loop for v in block-vars
                                                           concat (format " %s" v))))))

    ;; #+BEGIN_SRC
    (setq code-block-template (concat code-block-template
                                      (format "#+BEGIN_SRC %s :results output"
                                              block-language)))
    (unless (equal block-output-type "")
      (setq code-block-template (concat code-block-template
                                        (format " %s\n" block-output-type))))

    ;; #+END_SRC
    (concat code-block-template "#+END_SRC")))
