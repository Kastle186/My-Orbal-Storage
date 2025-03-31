;; *********************************************
;;  Enhancing Keywords and Syntax Highlighting!
;; *********************************************

;; Keywords not highlighted by default but I believe should be.

(defvar my-elisp-keywords '(("\\_<add-hook\\_>"             . font-lock-builtin-face)
                            ("\\_<add-to-list\\_>"          . font-lock-builtin-face)
                            ("\\_<ash\\_>"                  . font-lock-builtin-face)
                            ("\\_<assq\\_>"                 . font-lock-builtin-face)
                            ("\\_<capitalize\\_>"           . font-lock-builtin-face)
                            ("\\_<car\\_>"                  . font-lock-builtin-face)
                            ("\\_<cdr\\_>"                  . font-lock-builtin-face)
                            ("\\_<concat\\_>"               . font-lock-builtin-face)
                            ("\\_<custom-set-faces\\_>"     . font-lock-builtin-face)
                            ("\\_<custom-set-variables\\_>" . font-lock-builtin-face)
                            ("\\_<define-key\\_>"           . font-lock-builtin-face)
                            ("\\_<downcase\\_>"             . font-lock-builtin-face)
                            ("\\_<eq\\_>"                   . font-lock-builtin-face)
                            ("\\_<eql\\_>"                  . font-lock-builtin-face)
                            ("\\_<equal\\_>"                . font-lock-builtin-face)
                            ("\\_<flatten-tree\\_>"         . font-lock-builtin-face)
                            ("\\_<format\\_>"               . font-lock-builtin-face)
                            ("\\_<get-buffer-create\\_>"    . font-lock-builtin-face)
                            ("\\_<getenv\\_>"               . font-lock-builtin-face)
                            ("\\_<gethash\\_>"              . font-lock-builtin-face)
                            ("\\_<global-set-key\\_>"       . font-lock-builtin-face)
                            ("\\_<global-unset-key\\_>"     . font-lock-builtin-face)
                            ("\\_<insert\\_>"               . font-lock-builtin-face)
                            ("\\_<insert-file-contents\\_>" . font-lock-builtin-face)
                            ("\\_<kbd\\_>"                  . font-lock-builtin-face)
                            ("\\_<length\\_>"               . font-lock-builtin-face)
                            ("\\_<last\\_>"                 . font-lock-builtin-face)
                            ("\\_<list\\_>"                 . font-lock-builtin-face)
                            ("\\_<load-file\\_>"            . font-lock-builtin-face)
                            ("\\_<logand\\_>"               . font-lock-builtin-face)
                            ("\\_<logcount\\_>"             . font-lock-builtin-face)
                            ("\\_<logior\\_>"               . font-lock-builtin-face)
                            ("\\_<lognot\\_>"               . font-lock-builtin-face)
                            ("\\_<logxor\\_>"               . font-lock-builtin-face)
                            ("\\_<lsh\\_>"                  . font-lock-builtin-face)
                            ("\\_<mapc\\_>"                 . font-lock-builtin-face)
                            ("\\_<mapcan\\_>"               . font-lock-builtin-face)
                            ("\\_<mapcar\\_>"               . font-lock-builtin-face)
                            ("\\_<mapconcat\\_>"            . font-lock-builtin-face)
                            ("\\_<member\\_>"               . font-lock-builtin-face)
                            ("\\_<message\\_>"              . font-lock-builtin-face)
                            ("\\_<nil\\_>"                  . font-lock-keyword-face)
                            ("\\_<not\\_>"                  . font-lock-keyword-face)
                            ("\\_<ntake\\_>"                . font-lock-builtin-face)
                            ("\\_<nth\\_>"                  . font-lock-builtin-face)
                            ("\\_<nthcdr\\_>"               . font-lock-builtin-face)
                            ("\\_<number-to-string\\_>"     . font-lock-builtin-face)
                            ("\\_<pop\\_>"                  . font-lock-builtin-face)
                            ("\\_<put\\_>"                  . font-lock-builtin-face)
                            ("\\_<puthash\\_>"              . font-lock-builtin-face)
                            ("\\_<seq-map\\_>"              . font-lock-builtin-face)
                            ("\\_<seq-mapn\\_>"             . font-lock-builtin-face)
                            ("\\_<seq-map-indexed\\_>"      . font-lock-builtin-face)
                            ("\\_<set\\_>"                  . font-lock-builtin-face)
                            ("\\_<setenv\\_>"               . font-lock-builtin-face)
                            ("\\_<split-string\\_>"         . font-lock-builtin-face)
                            ("\\_<string-to-number\\_>"     . font-lock-builtin-face)
                            ("\\_<substring\\_>"            . font-lock-builtin-face)
                            ("\\_<t\\_>"                    . font-lock-keyword-face)
                            ("\\_<take\\_>"                 . font-lock-builtin-face)
                            ("\\_<upcase\\_>"               . font-lock-builtin-face)))

(defvar my-c-language-keywords '(("\\_<abs\\_>"     . font-lock-builtin-face)
                                 ("\\_<bool\\_>"    . font-lock-type-face)
                                 ("\\_<calloc\\_>"  . font-lock-builtin-face)
                                 ("\\_<fclose\\_>"  . font-lock-builtin-face)
                                 ("\\_<fgets\\_>"   . font-lock-builtin-face)
                                 ("\\_<fopen\\_>"   . font-lock-builtin-face)
                                 ("\\_<fprintf\\_>" . font-lock-builtin-face)
                                 ("\\_<free\\_>"    . font-lock-builtin-face)
                                 ("\\_<malloc\\_>"  . font-lock-builtin-face)
                                 ("\\_<memcpy\\_>"  . font-lock-builtin-face)
                                 ("\\_<memset\\_>"  . font-lock-builtin-face)
                                 ("\\_<pid_t\\_>"   . font-lock-type-face)
                                 ("\\_<printf\\_>"  . font-lock-builtin-face)
                                 ("\\_<putc\\_>"    . font-lock-builtin-face)
                                 ("\\_<putchar\\_>" . font-lock-builtin-face)
                                 ("\\_<puts\\_>"    . font-lock-builtin-face)
                                 ("\\_<realloc\\_>" . font-lock-builtin-face)
                                 ("\\_<scanf\\_>"   . font-lock-builtin-face)
                                 ("\\_<sizeof\\_>"  . font-lock-keyword-face)
                                 ("\\_<size_t\\_>"  . font-lock-type-face)
                                 ("\\_<sprintf\\_>" . font-lock-builtin-face)
                                 ("\\_<sscanf\\_>"  . font-lock-builtin-face)
                                 ("\\_<stderr\\_>"  . font-lock-keyword-face)
                                 ("\\_<stdin\\_>"   . font-lock-keyword-face)
                                 ("\\_<stdout\\_>"  . font-lock-keyword-face)
                                 ("\\_<strcmp\\_>"  . font-lock-builtin-face)
                                 ("\\_<strcpy\\_>"  . font-lock-builtin-face)
                                 ("\\_<strlen\\_>"  . font-lock-builtin-face)
                                 ("\\_<strncpy\\_>" . font-lock-builtin-face)
                                 ("\\_<strtok\\_>"  . font-lock-builtin-face)
                                 ("\\_<strtol\\_>"  . font-lock-builtin-face)
                                 ("\\_<FILE\\_>"    . font-lock-type-face)
                                 ("\\_<NULL\\_>"    . font-lock-keyword-face)

                                 ("\\_<\\([A-Za-z0-9_]+\\)(" 1 font-lock-function-name-face)))

(defvar my-c++-keywords '(("\\_<cin\\_>"     . font-lock-keyword-face)
                          ("\\_<cout\\_>"    . font-lock-keyword-face)
                          ("\\_<endl\\_>"    . font-lock-keyword-face)
                          ("\\_<getline\\_>" . font-lock-keyword-face)

                          ("\\_<\\([A-Za-z0-9_]+\\)(" 1 font-lock-function-name-face)))

(defvar my-erlang-keywords '(("\\_<error\\_>" . font-lock-keyword-face)
                             ("\\_<false\\_>" . font-lock-keyword-face)
                             ("\\_<ok\\_>"    . font-lock-keyword-face)
                             ("\\_<true\\_>"  . font-lock-keyword-face)))

(defvar my-go-keywords '(("\\_<\\(fmt\\).\\(Println\\)\\_>" 2 font-lock-builtin-face)))

(defvar my-java-keywords '(("\\_<length\\_>"  . font-lock-builtin-face)
                           ("\\_<print\\_>"   . font-lock-builtin-face)
                           ("\\_<println\\_>" . font-lock-builtin-face)

                           ("\\_<\\(Math\\).\\(max\\)"   2 font-lock-builtin-face)
                           ("\\_<\\(Math\\).\\(min\\)"   2 font-lock-builtin-face)
                           ("\\_<\\(System\\).\\(out\\)" 2 font-lock-keyword-face)
                           ("\\_<\\([A-Za-z0-9_]+\\)("   1 font-lock-function-name-face)))

(defvar my-js-keywords '(("\\_<abs\\_>"      . font-lock-builtin-face)
                         ("\\_<filter\\_>"   . font-lock-builtin-face)
                         ("\\_<from\\_>"     . font-lock-keyword-face)
                         ("\\_<function\\_>" . font-lock-keyword-face)
                         ("\\_<length\\_>"   . font-lock-builtin-face)
                         ("\\_<max\\_>"      . font-lock-builtin-face)
                         ("\\_<min\\_>"      . font-lock-builtin-face)
                         ("\\_<parseInt\\_>" . font-lock-builtin-face)
                         ("\\_<pop\\_>"      . font-lock-builtin-face)
                         ("\\_<push\\_>"     . font-lock-builtin-face)
                         ("\\_<shift\\_>"    . font-lock-builtin-face)
                         ("\\_<splice\\_>"   . font-lock-builtin-face)
                         ("\\_<split\\_>"    . font-lock-builtin-face)
                         ("\\_<trim\\_>"     . font-lock-builtin-face)
                         ("\\_<BigInt\\_>"   . font-lock-type-face)
                         ("\\_<Number\\_>"   . font-lock-type-face)

                         ("\\_<\\(console\\).\\(log\\)("
                          2 font-lock-builtin-face)

                         ("\\_<\\(new\\)[[:space:]]+\\([A-Za-z0-9_]+\\)"
                          2 font-lock-type-face)

                         ("\\_<\\([A-Za-z0-9_]+\\)("
                          1 font-lock-function-name-face)))

(defvar my-julia-keywords '(("\\_<ARGS\\_>"           . font-lock-variable-name-face)

                            ("\\_<append[!]?\\_>"     . font-lock-builtin-face)
                            ("\\_<cmp\\_>"            . font-lock-builtin-face)
                            ("\\_<eachline\\_>"       . font-lock-builtin-face)
                            ("\\_<eof\\_>"            . font-lock-builtin-face)
                            ("\\_<eachindex\\_>"      . font-lock-builtin-face)
                            ("\\_<findfirst\\_>"      . font-lock-builtin-face)
                            ("\\_<get[!]?\\_>"        . font-lock-builtin-face)
                            ("\\_<getfield\\_>"       . font-lock-builtin-face)
                            ("\\_<getproperty\\_>"    . font-lock-builtin-face)
                            ("\\_<[!]?haskey\\_>"     . font-lock-builtin-face)
                            ("\\_<include\\_>"        . font-lock-keyword-face)
                            ("\\_<[!]?isdir\\_>"      . font-lock-builtin-face)
                            ("\\_<[!]?isempty\\_>"    . font-lock-builtin-face)
                            ("\\_<[!]?isfile\\_>"     . font-lock-builtin-face)
                            ("\\_<[!]?ispath\\_>"     . font-lock-builtin-face)
                            ("\\_<join\\_>"           . font-lock-builtin-face)
                            ("\\_<length\\_>"         . font-lock-builtin-face)
                            ("\\_<lowercase\\_>"      . font-lock-builtin-face)
                            ("\\_<map[!]?\\_>"        . font-lock-builtin-face)
                            ("\\_<occursin\\_>"       . font-lock-builtin-face)
                            ("\\_<open\\_>"           . font-lock-builtin-face)
                            ("\\_<parse\\_>"          . font-lock-builtin-face)
                            ("\\_<pop[!]?\\_>"        . font-lock-builtin-face)
                            ("\\_<print\\_>"          . font-lock-builtin-face)
                            ("\\_<println\\_>"        . font-lock-builtin-face)
                            ("\\_<push[!]?\\_>"       . font-lock-builtin-face)
                            ("\\_<rand\\_>"           . font-lock-builtin-face)
                            ("\\_<read\\_>"           . font-lock-builtin-face)
                            ("\\_<readline\\_>"       . font-lock-builtin-face)
                            ("\\_<readlines\\_>"      . font-lock-builtin-face)
                            ("\\_<sort[!]?\\_>"       . font-lock-builtin-face)
                            ("\\_<split\\_>"          . font-lock-builtin-face)
                            ("\\_<startswith\\_>"     . font-lock-builtin-face)
                            ("\\_<stdin\\_>"          . font-lock-constant-face)
                            ("\\_<stdout\\_>"         . font-lock-constant-face)
                            ("\\_<[lr]?strip\\_>"     . font-lock-builtin-face)
                            ("\\_<uppercase\\_>"      . font-lock-builtin-face)
                            ("\\_<uppercasefirst\\_>" . font-lock-builtin-face)

                            ("\\_<Any\\_>"            . font-lock-type-face)
                            ("\\_<AbstractString\\_>" . font-lock-type-face)
                            ("\\_<AbstractVector\\_>" . font-lock-type-face)
                            ("\\_<Array\\_>"          . font-lock-type-face)
                            ("\\_<Bool\\_>"           . font-lock-type-face)
                            ("\\_<Complex\\_>"        . font-lock-type-face)
                            ("\\_<Dict\\_>"           . font-lock-type-face)
                            ("\\_<Float\\_>"          . font-lock-type-face)
                            ("\\_<Float32\\_>"        . font-lock-type-face)
                            ("\\_<Float64\\_>"        . font-lock-type-face)
                            ("\\_<Int\\_>"            . font-lock-type-face)
                            ("\\_<Int32\\_>"          . font-lock-type-face)
                            ("\\_<Int64\\_>"          . font-lock-type-face)
                            ("\\_<Integer\\_>"        . font-lock-type-face)
                            ("\\_<Matrix\\_>"         . font-lock-type-face)
                            ("\\_<NamedTuple\\_>"     . font-lock-type-face)
                            ("\\_<Nothing\\_>"        . font-lock-type-face)
                            ("\\_<Ptr\\_>"            . font-lock-type-face)
                            ("\\_<Real\\_>"           . font-lock-type-face)
                            ("\\_<String\\_>"         . font-lock-type-face)
                            ("\\_<Symbol\\_>"         . font-lock-type-face)
                            ("\\_<Tuple\\_>"          . font-lock-type-face)
                            ("\\_<Vector\\_>"         . font-lock-type-face)))

(defvar my-python-keywords '(("\\_<all\\_>"         . font-lock-builtin-face)
                             ("\\_<any\\_>"         . font-lock-builtin-face)
                             ("\\_<append\\_>"      . font-lock-builtin-face)
                             ("\\_<chr\\_>"         . font-lock-builtin-face)
                             ("\\_<float\\_>"       . font-lock-builtin-face)
                             ("\\_<input\\_>"       . font-lock-builtin-face)
                             ("\\_<int\\_>"         . font-lock-builtin-face)
                             ("\\_<join\\_>"        . font-lock-builtin-face)
                             ("\\_<len\\_>"         . font-lock-builtin-face)
                             ("\\_<list\\_>"        . font-lock-builtin-face)
                             ("\\_<map\\_>"         . font-lock-builtin-face)
                             ("\\_<max\\_>"         . font-lock-builtin-face)
                             ("\\_<min\\_>"         . font-lock-builtin-face)
                             ("\\_<namedtuple\\_>"  . font-lock-type-face)
                             ("\\_<print\\_>"       . font-lock-builtin-face)
                             ("\\_<range\\_>"       . font-lock-builtin-face)
                             ("\\_<set\\_>"         . font-lock-builtin-face)
                             ("\\_<sort\\_>"        . font-lock-builtin-face)
                             ("\\_<sorted\\_>"      . font-lock-builtin-face)
                             ("\\_<split\\_>"       . font-lock-builtin-face)
                             ("\\_<str\\_>"         . font-lock-builtin-face)
                             ("\\_<[l|r]?strip\\_>" . font-lock-builtin-face)

                             ("\\_<Final\\_>"       . font-lock-type-face)
                             ("\\_<TypeAlias\\_>"   . font-lock-type-face)
                             ("\\_<Self\\_>"        . font-lock-type-face)
                             ("\\_<Union\\_>"       . font-lock-type-face)

                             ("\\_<\\([A-Za-z0-9_]+\\)(" 1 font-lock-function-name-face)))

(defvar my-ruby-keywords '(("\\_<abs\\_>"             . font-lock-builtin-face)
                           ("\\_<any[?]\\_>"          . font-lock-builtin-face)
                           ("\\_<capitalize[!]?\\_>"  . font-lock-builtin-face)
                           ("\\_<chars\\_>"           . font-lock-builtin-face)
                           ("\\_<chomp[!]?\\_>"       . font-lock-builtin-face)
                           ("\\_<count\\_>"           . font-lock-builtin-face)
                           ("\\_<delete[!]?\\_>"      . font-lock-builtin-face)
                           ("\\_<empty\\?\\_>"        . font-lock-builtin-face)
                           ("\\_<filter[!]?\\_>"      . font-lock-builtin-face)
                           ("\\_<flatten[!]?\\_>"     . font-lock-builtin-face)
                           ("\\_<gets\\_>"            . font-lock-builtin-face)
                           ("\\_<each\\_>"            . font-lock-builtin-face)
                           ("\\_<each_pair\\_>"       . font-lock-builtin-face)
                           ("\\_<each_with_index\\_>" . font-lock-builtin-face)
                           ("\\_<inject\\_>"          . font-lock-builtin-face)
                           ("\\_<length\\_>"          . font-lock-builtin-face)
                           ("\\_<map[!]?\\_>"         . font-lock-builtin-face)
                           ("\\_<max\\_>"             . font-lock-builtin-face)
                           ("\\_<min\\_>"             . font-lock-builtin-face)
                           ("\\_<pop\\_>"             . font-lock-builtin-face)
                           ("\\_<push\\_>"            . font-lock-builtin-face)
                           ("\\_<reduce\\_>"          . font-lock-builtin-face)
                           ("\\_<reverse[!]?\\_>"     . font-lock-builtin-face)
                           ("\\_<reverse[!]?\\_>"     . font-lock-builtin-face)
                           ("\\_<select[!]?\\_>"      . font-lock-builtin-face)
                           ("\\_<size\\_>"            . font-lock-builtin-face)
                           ("\\_<sort[!]?\\_>"        . font-lock-builtin-face)
                           ("\\_<split\\_>"           . font-lock-builtin-face)
                           ("\\_<to_f\\_>"            . font-lock-builtin-face)
                           ("\\_<to_h\\_>"            . font-lock-builtin-face)
                           ("\\_<to_i\\_>"            . font-lock-builtin-face)
                           ("\\_<to_s\\_>"            . font-lock-builtin-face)
                           ("\\_<uniq[!]?\\_>"        . font-lock-builtin-face)
                           ("\\_<upto\\_>"            . font-lock-builtin-face)
                           ("\\_<zip\\_>"             . font-lock-builtin-face)

                           ("\\_<\\([A-Za-z0-9_]+\\)(" 1 font-lock-function-name-face)))

(defvar my-rust-keywords '(("\\_<enumerate\\_>" . font-lock-builtin-face)
                           ("\\_<iter\\_>"      . font-lock-keyword-face)
                           ("\\_<iter_mut\\_>"  . font-lock-keyword-face)
                           ("\\_<len\\_>"       . font-lock-builtin-face)
                           ("\\_<max\\_>"       . font-lock-builtin-face)
                           ("\\_<new\\_>"       . font-lock-keyword-face)
                           ("\\_<push\\_>"      . font-lock-builtin-face)
                           ("\\_<rev\\_>"       . font-lock-builtin-face)
                           ("\\_<unwrap\\_>"    . font-lock-keyword-face)
                           ("\\_<\\([A-Za-z0-9_]+\\)(" 1 font-lock-function-name-face)))

(defvar my-shell-keywords '(("\\_<local\\_>" . font-lock-keyword-face)))
