;; *********************************************
;;  Japanese Dictionary Org-Mode Configuration!
;; *********************************************

(setq is-for-lexicon nil)

;; *********************************
;;  New Item Data Prompt Functions!
;; *********************************

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


;; ***********************
;; (get-word-written-form)
;; ***********************
;; Most words have at least a kanji in their way of writing them. We also want to
;; record the hiragana-only writing to be able to easily review how they are
;; pronounced, since memorizing kanji's pronunciations is... not gonna happen.

(defun get-word-written-form (spelling-type)
  "Prompt for the word's writing. This function is usually called twice per word
capture: One for kanji+hiragana or katakana, and one for hiragana-only."
  (let ((word-writing (read-string
                       (format "Enter the word's %s spelling: " spelling-type))))
    (format "%s" word-writing)))


;; ************
;; get-new-word
;; ************
;; Get the new word's information: Hiragana writing, Kanji writing if the word has
;; one, and the word's definition in English.

(defun get-new-word ()
  "Prompt for the word's necessary information to record it to the lexicon and
the dictionary."
  (let ((hiragana-writing (get-word-written-form "hiragana"))
        (kanji-writing (get-word-written-form "kanji"))
        (word-type (get-suru-na-if-so))
        (definition (read-string "Enter the word's definition in English: ")))

    (record-word-to-dictionary hiragana-writing kanji-writing word-type definition)
    (if (y-or-n-p "Will this word be added to a lexicon file? ")
        (progn
          (setq is-for-lexicon t)
          (format "%s%s (%s): %s\n"
                  kanji-writing
                  word-type
                  hiragana-writing
                  definition))
      nil)))


;; ****************
;; get-new-sentence
;; ****************
;; Get an example sentence in Japanese with it's English translation.

(defun get-new-sentence ()
  "Prompt for the example sentence in Japanese, and then for its English translation.
If the 'good/official' English translation differs from how it would be if translated
literally, there is another prompt afterwards to retrieve this case."
  (setq is-for-lexicon t)
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


;; ********************
;; get-word-found-place
;; ********************
;; We are adding support to select the file where we want to add the new word
;; at will during runtime. This little function is like the main hub that delegates
;; finding the word's new place to the appropriate function, depending on what kind
;; of file we will be working with.

(defun get-word-found-place ()
  "Ask whether this word will be added to a lexicon file, and find the appropriate
location for it in this case. If not, then it means it will only be added to a
dictionary, and for that case, everything is taken care of by the dictionary word
recording function."
  (when is-for-lexicon
    (let ((lex-file (read-file-name "Enter the lexicon's file path: ")))
      (get-lexicon-word-place lex-file)))
  (setq is-for-lexicon nil))


;; **********************
;; get-lexicon-word-place
;; **********************
;; We will be classifying our words per semantic field in which we found them. So,
;; we have to specify said field when filing the individual words' information. This
;; function asks and retrieves that information.

(defun get-lexicon-word-place (lex-file)
  "Prompt for the source of where the given word was found, and move the cursor to
said position in the lexicon file."
  (find-file lex-file)
  (let ((place (read-string "Enter the place you found the word at: ")))
    (if-let ((header-pos (org-find-exact-headline-in-buffer place)))
        (progn
          (goto-char header-pos)
          (if (org-goto-sibling)
              (forward-line -1)
            (goto-char (point-max))))
      (goto-char (point-max)))))


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
             '("w" "New Japanese Word"
               item (function get-word-found-place)
               #'get-new-word
               :empty-lines 0 :immediate-finish t :jump-to-captured t)
             t)

(add-to-list 'org-capture-templates
             '("e" "New Japanese Sentence Example"
               plain (function get-word-found-place)
               #'get-new-sentence
               :empty-lines-after 1 :immediate-finish t :jump-to-captured t)
             t)
