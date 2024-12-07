;; *********************
;; Additional Utilities!
;; *********************

;; This little file will contain some additional little tools I've found or created,
;; that have come to be really helpful whenever I'd needed them.

;; (Display-Unavailable-Packages)

(defun display-unavailable-packages ()
  "Ask Emacs' package manager which ones described in 'package-selected-packages
are no longer/not available for installation."
  (interactive)
  (let* ((notinstalled (seq-remove #'package-installed-p package-selected-packages))
         (notavailable (seq-filter (lambda (p) (not (assq p package-archive-contents)))
                                   notinstalled)))
    (if (equal (length notavailable) 0)
        "There are no unavailable packages at this moment :)"
      notavailable)))

;; (Last-Element)

(defun last-element (list &optional n)
  "Returns the last nth element of the given list as an item, as opposed to Emacs'
builtin function, (last), which returns the last element as a list."
  (when (not n)
    (setq n 1))
  (nth (- (length list) n) list))
