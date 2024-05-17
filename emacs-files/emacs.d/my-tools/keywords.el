;; *********************************************
;;  Enhancing Keywords and Syntax Highlighting!
;; *********************************************

;; Keywords not highlighted by default but I believe should be.

(font-lock-add-keywords 'emacs-lisp-mode
                        '(("\\_<add-hook\\_>"             . font-lock-builtin-face)
                          ("\\_<add-to-list\\_>"          . font-lock-builtin-face)
                          ("\\_<assq\\_>"                 . font-lock-builtin-face)
                          ("\\_<capitalize\\_>"           . font-lock-builtin-face)
                          ("\\_<concat\\_>"               . font-lock-builtin-face)
                          ("\\_<custom-set-faces\\_>"     . font-lock-builtin-face)
                          ("\\_<custom-set-variables\\_>" . font-lock-builtin-face)
                          ("\\_<define-key\\_>"           . font-lock-builtin-face)
                          ("\\_<downcase\\_>"             . font-lock-builtin-face)
                          ("\\_<eql\\_>"                  . font-lock-keyword-face)
                          ("\\_<equal\\_>"                . font-lock-builtin-face)
                          ("\\_<format\\_>"               . font-lock-builtin-face)
                          ("\\_<getenv\\_>"               . font-lock-builtin-face)
                          ("\\_<global-set-key\\_>"       . font-lock-builtin-face)
                          ("\\_<global-unset-key\\_>"     . font-lock-builtin-face)
                          ("\\_<kbd\\_>"                  . font-lock-builtin-face)
                          ("\\_<length\\_>"               . font-lock-builtin-face)
                          ("\\_<load-file\\_>"            . font-lock-builtin-face)
                          ("\\_<member\\_>"               . font-lock-builtin-face)
                          ("\\_<nil\\_>"                  . font-lock-keyword-face)
                          ("\\_<not\\_>"                  . font-lock-keyword-face)
                          ("\\_<put\\_>"                  . font-lock-builtin-face)
                          ("\\_<set\\_>"                  . font-lock-builtin-face)
                          ("\\_<setenv\\_>"               . font-lock-builtin-face)
                          ("\\_<t\\_>"                    . font-lock-keyword-face)
                          ("\\_<upcase\\_>"               . font-lock-builtin-face)))

(font-lock-add-keywords 'csharp-mode
                        '(("\\_<init\\_>" . font-lock-keyword-face)))

(font-lock-add-keywords 'c-mode
                        '(("\\_<bool\\_>"    . font-lock-type-face)
                          ("\\_<calloc\\_>"  . font-lock-builtin-face)
                          ("\\_<fgets\\_>"   . font-lock-builtin-face)
                          ("\\_<free\\_>"    . font-lock-builtin-face)
                          ("\\_<malloc\\_>"  . font-lock-builtin-face)
                          ("\\_<pid_t\\_>"   . font-lock-type-face)
                          ("\\_<printf\\_>"  . font-lock-builtin-face)
                          ("\\_<putc\\_>"    . font-lock-builtin-face)
                          ("\\_<putchar\\_>" . font-lock-builtin-face)
                          ("\\_<puts\\_>"    . font-lock-builtin-face)
                          ("\\_<scanf\\_>"   . font-lock-builtin-face)
                          ("\\_<size_t\\_>"  . font-lock-type-face)
                          ("\\_<strcmp\\_>"  . font-lock-builtin-face)
                          ("\\_<strcpy\\_>"  . font-lock-builtin-face)
                          ("\\_<strlen\\_>"  . font-lock-builtin-face)
                          ("\\_<FILE\\_>"    . font-lock-type-face)))

(font-lock-add-keywords 'c++-mode
                        '(("\\_<cin\\_>"   . font-lock-keyword-face)
                          ("\\_<cout\\_>"  . font-lock-keyword-face)
                          ("\\_<endl\\_>"  . font-lock-keyword-face)))

(font-lock-add-keywords 'julia-mode
                        '(("\\_<isdir\\_>"          . font-lock-builtin-face)
                          ("\\_<isfile\\_>"         . font-lock-builtin-face)
                          ("\\_<ispath\\_>"         . font-lock-builtin-face)
                          ("\\_<lowercase\\_>"      . font-lock-builtin-face)
                          ("\\_<uppercase\\_>"      . font-lock-builtin-face)
                          ("\\_<uppercasefirst\\_>" . font-lock-builtin-face)))
