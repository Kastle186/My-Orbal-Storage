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

;; Load each personalized org-mode configuration files.

(load-file "~/.emacs.d/org-mode-config/japanese-dictionary-orgmode.el")
;; (load-file "~/.emacs.d/org-mode-config/dotnet-work-items-orgmode.el")
