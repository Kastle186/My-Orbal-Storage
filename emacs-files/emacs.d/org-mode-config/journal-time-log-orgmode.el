;; ******************************************
;;  Journal Time Log Org-Mode Configuration!
;; ******************************************

;; Let's save our org filenames in variables for easier access and better readability.

(defvar journal-time-log-file "~/Documents/Emacs/my-daily-journal.org")

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
               " [%<%k:%M %Z>] => %^{Activity} (%^{Duration})"
               :immediate-finish t :jump-to-captured t)
             t)
