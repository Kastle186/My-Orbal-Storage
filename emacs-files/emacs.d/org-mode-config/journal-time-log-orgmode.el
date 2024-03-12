;; ******************************************
;;  Journal Time Log Org-Mode Configuration!
;; ******************************************

;; Let's save our org filenames in variables for easier access and better readability.

(defvar journal-time-log-file "~/Documents/Emacs/my-daily-journal.org")
(defvar days-of-the-week '("Sunday"
                           "Monday"
                           "Tuesday"
                           "Wednesday"
                           "Thursday"
                           "Friday"
                           "Saturday"))

;; ****************************************
;; Journal Time and Information Functions!
;; ****************************************

;; ***************************
;; calculate-activity-summary
;; ***************************

(defun calculate-activity-summary (&optional date-arg)
  "Calculates the amount of time spent on each activity kind on a particular day,
and displays a nicely formatted summary. The activity kind is determined by the
tag set at the end of each log entry. If no tag was given, then it is considered
of the type \"Other\"."
  (let ((date-node (if date-arg (format-time-string "%Y-%m-%d %A" (date-to-time date-arg))
                     (format-time-string "%Y-%m-%d %A"))))
    (find-file journal-time-log-file)
    (goto-char (org-find-exact-headline-in-buffer date-node))
    (forward-line) ;; The activity log starts after the node headline :)

    (let ((next-entry (buffer-substring-no-properties (line-beginning-position)
                                                      (line-end-position))))
      (while (string-prefix-p "+" next-entry)
        ;; (message next-entry)
        (let ((entry-parts (split-string next-entry)))
          ;; Work with the parts to do the necessary calculations here.
          )
        (forward-line)
        (setq next-entry (buffer-substring-no-properties (line-beginning-position)
                                                         (line-end-position)))))))

;; *********************
;;  New Item Templates!
;; *********************

;; Since org-mode is for everyone, let's add the work journal entries capture
;; templates to emacs' "org-capture-templates", rather than setting it from
;; scratch. We don't want to delete the templates from other org-mode components
;; we might have initialized prior to this one :)

(add-to-list 'org-capture-templates
             '("J" "New Journal Entry"
               plain (file+datetree journal-time-log-file)
               "+ [%<%k:%M %Z>] => %^{Activity} (%^{Duration|0m})"
               :immediate-finish t :jump-to-captured t)
             t)
