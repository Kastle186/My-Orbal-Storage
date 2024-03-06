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

;; *********************
;; calculate-wasted-time
;; *********************
;; Helper function to calculate how much time was wasted on a particular day recorded
;; in the journal. In this context, "wasted time" is defined as the sum of all periods
;; of time where no activity was taking place.
;;
;; For example, let's assume 'Activity 1' took one hour to complete, and was subdivided
;; in two subtasks lasting 30 and 20 minutes respectively, then there were 50 minutes
;; of effective work taking place. Therefore, the amount of wasted time for that activity
;; was 10 minutes. Next, let's assume that 'Activity 2' and 'Activity 3' had 15 and 20
;; minutes of wasted time respectively. As a result, this function would return
;; 45 minutes of wasted time in that specific day.
;;
;; As for the format of the 'date-arg' parameter, it can be either a string of the
;; form 'yyyy-mm-dd', or a 2-element list containing the time, like the function
;; '(date-to-time)' returns.

(defun calculate-wasted-time (&optional date-arg)
  "Calculate and get the total amount of wasted time on a particular day."
  (let ((date-node (if date-arg
                       (format-time-string "%Y-%m-%d %A" (date-to-time date-arg))
                     (format-time-string "%Y-%m-%d %A"))))

    (find-file journal-time-log-file)
    (goto-char (org-find-exact-headline-in-buffer date-node))
    (forward-line) ;; The activity log starts after the node headline :)

    ;; Iterate each line until we get to one that doesn't start with a '+' sign.
    ;; That means we're no longer in the activity list we want to process.

    (let ((next-entry (buffer-substring-no-properties (line-beginning-position)
                                                      (line-end-position))))
      (while (string-prefix-p "+" next-entry)
        (let ((entry-parts (split-string next-entry))))
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
