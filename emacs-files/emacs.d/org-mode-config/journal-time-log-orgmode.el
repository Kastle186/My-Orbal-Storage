;; ******************************************
;;  Journal Time Log Org-Mode Configuration!
;; ******************************************

;; Let's save our org filenames in variables for easier access and better readability.

(defvar journal-time-log-file "~/Documents/Emacs/my-daily-journal.org")

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

(defun calculate-wasted-time ()
  "Calculate and get the total amount of wasted time on a particular day."
  "0m")

;; *********************
;;  New Item Templates!
;; *********************

;; Since org-mode is for everyone, let's add the work journal entries capture
;; templates to emacs' "org-capture-templates", rather than setting it from
;; scratch. We don't want to delete the templates from other org-mode components
;; we might have initialized prior to this one :)

(add-to-list 'org-capture-templates
             '("J" "New Journal Entry"
               item (file+datetree journal-time-log-file)
               " [%<%k:%M %Z>] => %^{Activity} (%^{Duration|0m})"
               :immediate-finish t :jump-to-captured t)
             t)
