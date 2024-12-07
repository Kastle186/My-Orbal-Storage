;; *********************************************
;;  Japanese Dictionary Org-Mode Configuration!
;; *********************************************

(setq word-first-syllable "")
(defvar words-temp-buffer-name "*Japanese of the Session*")

;; *********************************
;;  New Item Data Prompt Functions!
;; *********************************

;; ********************
;; get-word-for-lexicon
;; ********************
;; Helper function to add word to a lexicon because Emacs' org-mode templates are
;; being annoying.

(defun get-word-for-lexicon ()
  "Helper function to add word to a lexicon."
  (get-word-data nil))


;; ***********************
;; get-word-for-dictionary
;; ***********************
;; Helper function to add word to a dictionary because Emacs' org-mode templates
;; are being annoying.

(defun get-word-for-dictionary ()
  "Helper function to add word to a dictionary."
  (get-word-data t))


;; *************
;; get-word-data
;; *************
;; Get the new word's information: Hiragana writing, Kanji writing if the word has
;; one, and the word's definition in English. Most words have at least a kanji in
;; their way of writing them. We also want to record the hiragana-only writing to
;; be able to easily review how they are pronounced, since memorizing kanji's
;; pronunciations is... well... not gonna happen.

(defun get-word-data (dict-only)
  "Prompt for the word's necessary information to record it to the lexicon and/or
the dictionary."
  (let ((hiragana-writing (read-string "Enter the word's hiragana spelling: "))
        (kanji-writing (read-string "Enter the word's kanji representation: "))
        (word-type (get-suru-na-if-so))
        (english-def (read-string "Enter the word's definition in English: ")))

    (setq word-first-syllable (substring hiragana-writing 0 1))

    ;; FIXME: For dictionary-only inputs, it doesn't create the new syllable
    ;;        section, it only appends the word at the end.

    (when (and (not dict-only)
               (y-or-n-p "Will this word be added to a dictionary as well? "))
      (record-word-to-dictionary hiragana-writing
                                 kanji-writing
                                 word-type
                                 english-def))

    (let ((word-output (format "%s%s (%s): %s"
                               hiragana-writing
                               word-type
                               kanji-writing
                               english-def)))
      (save-word-to-temp-buffer word-output)
      word-output)))


;; *****************
;; get-suru-na-if-so
;; *****************
;; 'Suru' verbs and 'Na' adjectives use said suffixes to be identified. However,
;; they are only written with them in certain cases. Therefore, we want to write
;; them inside parentheses to show it's not an always used thing, or nothing at
;; all for the case of normal words.

(defun get-suru-na-if-so ()
  "Ask whether the current word is a 'suru' verb, 'na' adjective, or a normal word,
and return its suffix if needed."

  (let ((word-type (read-answer "Is Na-Adjective, Suru-Verb, or other? "
                                '(("na"   nil "Na-adjective")
                                  ("suru" nil "Suru-verb")
                                  (""     nil "Other word")))))

    (cond ((string-equal word-type "na")   "(な)")
          ((string-equal word-type "suru") "(する)")
          ((string-equal word-type "")     ""))))


;; *************************
;; get-dictionary-word-place
;; *************************
;; Explanation goes here :)

(defun get-dictionary-word-place ()
  "Prompt for the dictionary file path, and search for the starting syllable of the
word to add it there. If not found, add a new section with said syllable, and write
down the word there."
  (let ((dict-file (read-file-name "Enter the dictionary's file path: ")))
    (find-file dict-file)
    (if-let ((header-pos (org-find-exact-headline-in-buffer word-first-syllable)))
        (progn
          (goto-char header-pos)
          (if (org-goto-sibling)
              (forward-line -1)
            (goto-char (point-max))))
      (goto-char (point-max)))))


;; **********************
;; get-lexicon-word-place
;; **********************
;; We will be classifying our words per semantic field in which we found them. So,
;; we have to specify said field when filing the individual words' information. This
;; function asks and retrieves that information.

(defun get-lexicon-word-place ()
  "Prompt for the source of where the given word was found, and move the cursor to
said position in the lexicon file."
  (let ((lex-file (read-file-name "Enter the lexicon's file path: ")))
    (find-file lex-file)
    (let ((place (read-string "Enter the place you found the word at: ")))
      (if-let ((header-pos (org-find-exact-headline-in-buffer place)))
          (progn
            (goto-char header-pos)
            (if (org-goto-sibling)
                (forward-line -1)
              (goto-char (point-max))))
        (goto-char (point-max))))))


;; *************************
;; record-word-to-dictionary
;; *************************
;; Every time we add a new word to our lexicon, we also want it added to our dictionary,
;; so that we also have it in an easy way to look it up alphabetically... Or perhaps
;; I should say syllabarily :)
;;
;; A new update has come to this file: Now, we support adding to different lexicons
;; and/or different dictionaries. So, this function is in charge of the dictionary
;; adding in both cases.

(defun record-word-to-dictionary (hiragana kanji nasuru english)
  "Add captured word entry to its respective place in the dictionary after being
added to the lexicon, or if it was prompted to be a dictionary-only addition."
  (find-file (read-file-name "Enter the dictionary file path: "))
  (let* ((syllable (substring hiragana 0 1))
         (syl-header-pos (org-find-exact-headline-in-buffer syllable)))

    ;; FIXME: Compound syllables like じゅ for example, get treated as their root.
    ;;        In this case, じ. Need to add special handling for those to find
    ;;        their compound headers, instead of the base ones.

    (if syl-header-pos
        (progn
          (goto-char syl-header-pos)
          (if (org-goto-sibling)
              (forward-line -1)
            (goto-char (point-max))))
      (and
       (goto-char (point-max))
       (insert (format "\n** %s\n\n" syllable))))
    (insert (format "- %s%s (%s): %s\n" hiragana nasuru kanji english))))


;; *************************
;; save-word-to-temp-buffer
;; *************************
;; I've lost track of how many times I record and save a new word, only to need it
;; and have already forgot it right after. So, to solve this little personal problem,
;; we also create a temporary buffer where we store the words we've added during
;; the current Emacs session. Just as an easy way to look them up in these cases
;; that have annoyed me more than the should have :)

(defun save-word-to-temp-buffer (word-info)
  "Write the just captured word information on a temporary buffer for easier lookup
during the current Emacs session."
  (get-buffer-create words-temp-buffer-name)
  (with-current-buffer words-temp-buffer-name
    (goto-char (point-max))
    (insert (format "%s\n" word-info))))


;; ****************
;; get-new-sentence
;; ****************
;; Get an example sentence in Japanese with it's English translation.

(defun get-new-sentence ()
  "Prompt for the example sentence in Japanese, and then for its English translation.
If the 'good/official' English translation differs from how it would be if translated
literally, there is another prompt afterwards to retrieve this case."
  (let ((japanese-sentence (read-string
                            "Enter the example sentence in Japanese: "))
        (english-translation (read-string
                              "Enter the sentence's English translation: "))
        (literal-translation (read-string
                              "Enter the literal translation if it differs: ")))

    (if (string-empty-p literal-translation)
        (setq english-translation (concat english-translation "."))
      (setq english-translation (concat english-translation ". (/Lit./ " literal-translation ").")))
    (format "*- %s -> %s*" japanese-sentence english-translation)))


;; *********************
;;  New Item Templates!
;; *********************

;; Since org-mode is for everyone, let's add the japanese dictionary capture
;; templates to emacs' "org-capture-templates", rather than setting it from
;; scratch. We don't want to delete the templates from other org-mode components
;; we might have initialized prior to this one :)
;;
;; For better study, I like grouping the words I study by place where I learned
;; them. Makes it easier to remember, and look up whenever needed :)

(add-to-list 'org-capture-templates
             '("j" "New Place of Japanese Knowledge"
               entry (file+headline japanese-lexicon-file "Japanese Learning")
               "** %^{Word Source}"
               :empty-lines 1 :jump-to-captured t)
             t)

(add-to-list 'org-capture-templates
             '("w" "New Japanese Word (Lexicon and Dictionary)"
               item (function get-lexicon-word-place)
               #'get-word-for-lexicon
               :empty-lines-after 1 :immediate-finish t :jump-to-captured t)
             t)

(add-to-list 'org-capture-templates
             '("d" "New Japanese Word (Dictionary only)"
               item (function get-dictionary-word-place)
               #'get-word-for-dictionary
               :empty-lines-after 1 :immediate-finish t :jump-to-captured t)
             t)

(add-to-list 'org-capture-templates
             '("e" "New Japanese Sentence Example"
               plain (function get-lexicon-word-place)
               #'get-new-sentence
               :empty-lines-after 1 :immediate-finish t :jump-to-captured t)
             t)
