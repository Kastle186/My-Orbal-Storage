;; List containing the checkpoint characters for the *-word-conservative functions
;; defined later on.

;; KEY:
;;  9 = Tab
;; 10 = Newline/Line Feed
;; 11 = Vertical Tabulation
;; 12 = Form Feed
;; 32 = Space
;; 40 = Open Parenthesis
;; 41 = Close Parenthesis
;; 45 = Dash/Hyphen/Minus
;; 46 = Period/Dot/Full Stop
;; 47 = Slash/Divide
;; 58 = Colon
;; 59 = Semicolon
;; 60 = Open Angled Bracket/Less Than
;; 62 = Close Angled Bracket/Greater Than
;; 91 = Open Square Bracket
;; 92 = Backslash
;; 93 = Close Square Bracket
;; 95 = Underscore

(defvar boundary-symbols '(45 46 47 58 59 92 95))
(defvar opening-symbols '(40 60))
(defvar closing-symbols '(41 62))
(defvar whitespaces '(9 10 11 12 32))

;; Getter function to know whether a character is a word boundary defined by us.

(defun is-conservative-boundary (character)
  "Return 't' if CHARACTER is in one of the conservative boundary symbols lists,
or 'nil' otherwise."
  (or (member character boundary-symbols)
      (member character opening-symbols)
      (member character closing-symbols)
      (member character whitespaces)))

;; Getter function to know whether a character is an opening symbol defined by us.

(defun is-opening-symbol (character)
  "Return 't' if CHARACTER is in the 'opening-symbols' list, or 'nil' otherwise."
  (if (member character opening-symbols) t nil))

;; Getter function to know whether a character is a closing symbol defined by us.

(defun is-closing-symbol (character)
  "Return 't' if CHARACTER is in the 'closing-symbols' list, or 'nil' otherwise."
  (if (member character closing-symbols) t nil))

;; Getter function to know whether a character is an encapsulating bracket one
;; defined by us.

(defun is-bracket-symbol (character)
  "Return 't' if CHARACTER is in either the 'opening-symbols' or 'closing-symbols'
lists, or 'nil' otherwise."
  (if (or (is-opening-symbol character)
          (is-closing-symbol character))
      t nil))

;; Getter function to know whether a character is a whitespace one defined by us.

(defun is-whitespace (character)
  "Return 't' if CHARACTER is in the 'whitespaces' list, or 'nil' otherwise."
  (if (member character whitespaces) t nil))

;; Getter function to know whether a character is a spacing delimiter defined
;; by us (i.e. space or tab).

(defun is-spacing-delimiter (character)
  "Return 't' if CHARACTER is a space or a tab, or 'nil' otherwise."
  (or (equal 9 character)
      (equal 32 character)))

;; Function to jump forward between words without ignoring symbols-only words.

(defun forward-word-conservative (arg)
  "Move forward to the next word conservatively. In this context, conservatively
means to stop at the next boundary or word start character (i.e. 'words' made up
of just symbols also count as words). With argument ARG, do this that many times."
  (interactive "p")

  ;; A negative arg means we want to move backward, so we call the conservative
  ;; backwards word friend function.
  (if (< arg 0)
      (backward-word-conservative (* arg -1))
    (dotimes (number arg)

      (let ((start (char-after)))
        ;; If we begin on a normal text character, then first, we need to find its
        ;; boundary to define where we should go next.
        (while (not (is-conservative-boundary (char-after)))
          (forward-char))

        (cond (;; If we began at a section breaking character (e.g. newline), then
               ;; our next word starts at the first non-whitespace character.
               (and (is-whitespace (char-after))
                    (not (is-spacing-delimiter start)))
               (while (is-whitespace (char-after))
                 (forward-char)))

              ;; If we encounter a bracket symbol, then our next stop is the end of
              ;; that chain of brackets.
              ((is-bracket-symbol (char-after))
               (while (is-bracket-symbol (char-after))
                 (forward-char)))

              ;; If we encounter any other boundary symbol (e.g. hyphens, underscores),
              ;; then our next stop is what comes after them.
              (t (while (and (is-conservative-boundary (char-after))
                             (not (is-whitespace (char-after))))
                   (forward-char))))

        ;; If we began on any character other than section boundaries, and we ended
        ;; up on a space after all the movements in the previous 'cond' statement,
        ;; then we continue until we find our next word or the end of the current line.
        (unless (and (is-whitespace start)
                     (not (is-spacing-delimiter start)))
          (while (is-spacing-delimiter (char-after))
            (forward-char)))))))

;; Function to jump backward between words without ignoring symbols-only words.

(defun backward-word-conservative (arg)
  "Move backward to the previous word conservatively. In this context, conservatively
means to stop at the previous boundary or word start character (i.e. 'words' made up
of just symbols also count as words). With argument ARG, do this that many times."
  (interactive "p")

  ;; A negative arg means we want to move forward, so we call the conservative
  ;; forwards word friend function.
  (if (< arg 0)
      (forward-word-conservative (* arg -1))
    (dotimes (number arg)

      (cond (;; If we begin on a character whose previous neighbor is a whitespace
             ;; one, then the first step is to get to the previous non-whitespace
             ;; character. The next step is handled after this 'cond' statement.
             (is-whitespace (char-before))
             (backward-char)
             (while (is-whitespace (char-after))
               (backward-char)))

            ;; If we begin on a bracket symbol, then similarly to whitespaces, we
            ;; need to find the previous non-bracket symbol character.
            ((is-bracket-symbol (char-after))
             (while (is-bracket-symbol (char-after))
               (backward-char)))

            ;; If we begin on any boundary symbol other than brackets and whitespaces,
            ;; then the first step is to find the previous character that is not
            ;; a boundary character or whitespace. Whitespace is also considered as a
            ;; stopping point because being next to a whitespace character means we're
            ;; already at the beginning of the word, by definition.
            ((is-conservative-boundary (char-before))
             (while (and (is-conservative-boundary (char-before))
                         (not (is-whitespace (char-before))))
               (backward-char))))

      ;; After all the potentially done work in the previous 'cond' statement, we
      ;; are very most likely to be on a normal text character. In this case, then
      ;; our goal is the first previous text character that follows a boundary one.
      (while (not (is-conservative-boundary (char-before)))
        (backward-char))

      ;; There is a specific case where after all the work done previously in this
      ;; function, we will still end up on a non-whitespace boundary character.
      ;; This specific case happens when the previous word is composed of only
      ;; boundary characters. In such case, then our previous word's beginning is
      ;; after the previous non-boundary character.
      (when (is-conservative-boundary (char-after))
        (while (and (is-conservative-boundary (char-before))
                    (not (is-whitespace (char-before))))
          (backward-char))

        ;; This additional loop might look strange but it's needed for this specific
        ;; case. Let's take the following example:
        ;;
        ;;   test-before(((( ___boundarycase))))
        ;;
        ;; If we do 'backward-word-conservative' without this additional loop,
        ;; starting the cursor at the following position, with an asterisk (1):
        ;;
        ;;   1. test-before(((( *__boundarycase))))
        ;;   2. test-before*((( ___boundarycase))))
        ;;   3. test-*efore(((( ___boundarycase))))
        ;;
        ;; Then we end up at the first opening parenthesis character (2). This would
        ;; be correct if there was whitespace before said parenthesis, but there is
        ;; text in this case. So, the fully correct version should move the cursor
        ;; to the beginning of that text (3).
        (while (and (not (is-conservative-boundary (char-before)))
                    (not (is-whitespace (char-before))))
          (backward-char))))))

