;; *************************
;;  Org-Mode Configuration!
;; *************************

;; It looks nicer when we just have the bolds, italics, etc, without the special
;; symbols that tell Emacs to use them :)

(setq org-hide-emphasis-markers t)

;; Indented items look nicer and are easier to read :)

(setq org-indent-mode t)
(add-hook 'org-mode-hook 'org-indent-mode)

;; Ensure 'org-capture-templates is defined.

(unless (boundp 'org-capture-templates)
  (setq-default org-capture-templates '()))

;; Simple template for writing code snippets in org mode.

(define-skeleton org-code-block-template
  "Generate a basic template for an org-mode babel code block. This includes the
name, header, and source segments."
  ""
  > "#+NAME: " (skeleton-read "Code Block's Name (if any): ") \n
  > "#+HEADER: :var" \n
  > "#+BEGIN_SRC " (skeleton-read "Code Block's language: ") " :results output" \n
  > \n
  > "#+END_SRC")

;; Load each personalized org-mode configuration files.

(load-file "~/.emacs.d/org-mode-config/japanese-dictionary-orgmode.el")
