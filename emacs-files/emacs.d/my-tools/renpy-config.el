;; *********************
;; Ren'Py Configuration!
;; *********************

;; Set Ren'py files as Python ones, so that Emacs knows to enable python-mode
;; whenever we work with Ren'py.

(add-to-list 'auto-mode-alist '("\\.rpy\\'" . python-mode))

;; Add Ren'py-specific keywords to Python mode, but only when working with
;; Ren'py files (i.e. have the ".rpy" extension).

(add-hook 'python-mode-hook
          (lambda ()
            (when (and (stringp buffer-file-name)
                       (string-match "\\.rpy\\'" buffer-file-name))
              (font-lock-add-keywords 'python-mode
                                      '(("\\(^\\|\s+\\)alpha\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)at\\>"         . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)default\\>"    . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)define\\>"     . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)hide\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)image\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)init\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)jump\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)label\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)parallel\\>"   . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)pause\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)play\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)properties\\>" . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)queue\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)repeat\\>"     . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)rotate\\>"     . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)rotate_pad\\>" . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)scene\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)screen\\>"     . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)show\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)stop\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)style\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)text\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)transform\\>"  . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)use\\>"        . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)with\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)xalign\\>"     . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)xanchor\\>"    . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)xpan\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)xpos\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)xtile\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)xzoom\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)yalign\\>"     . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)yanchor\\>"    . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)ypan\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)ypos\\>"       . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)ytile\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)yzoom\\>"      . font-lock-keyword-face)
                                        ("\\(^\\|\s+\\)zoom\\>"       . font-lock-keyword-face)

                                        ("\s+crop\\>"                 . font-lock-builtin-face)
                                        ("\s+dissolve\\>"             . font-lock-builtin-face)
                                        ("\s+fade\\>"                 . font-lock-builtin-face)
                                        ("\s+fadein\\>"               . font-lock-builtin-face)
                                        ("\s+fadeout\\>"              . font-lock-builtin-face)
                                        ("\s+loop\\>"                 . font-lock-builtin-face)
                                        ("\s+noloop\\>"               . font-lock-builtin-face)
                                        ("\s+wipedown\\>"             . font-lock-builtin-face)
                                        ("\s+wipeleft\\>"             . font-lock-builtin-face)
                                        ("\s+wiperight\\>"            . font-lock-builtin-face)
                                        ("\s+wipeup\\>"               . font-lock-builtin-face)
                                        ("\\(^\\|\s+\\)linear\\>"     . font-lock-builtin-face)
                                        ("\\(^\\|\s+\\)\\(python\\):" 2 font-lock-builtin-face)
                                        ("\\(^\\|\s+\\)size\\>"       . font-lock-builtin-face)

                                        ("\\(^\\|\s+\\)hide\s+\\(.*\\)"   2 font-lock-variable-name-face)
                                        ("\\(^\\|\s+\\)jump\s+\\(.*\\)"   2 font-lock-variable-name-face)
                                        ("\\(^\\|\s+\\)label\s+\\(.*\\)"  2 font-lock-variable-name-face)
                                        ("\\(^\\|\s+\\)play\s+\\(\\w+\\)" 2 font-lock-variable-name-face)
                                        ("\\(^\\|\s+\\)scene\s+\\(.*\\)"  2 font-lock-variable-name-face)
                                        ("\\(^\\|\s+\\)show\s+\\(.*\\)"   2 font-lock-variable-name-face))))))
