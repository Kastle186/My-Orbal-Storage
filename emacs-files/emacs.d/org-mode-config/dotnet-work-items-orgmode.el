;; *************************
;;  Org-Mode Configuration!
;; *************************

;; Let's save our org filenames in variables for easier access and better readability.

(defvar dotnet-work-todos-file "~/Documents/Emacs/dotnet-todos.org")

;; Setting priorities to be with numbers.

(setq org-highest-priority 0)
(setq org-lowest-priority 3)
(setq org-default-priority 2)

;; **********************************
;;  Work Item Information Functions!
;; **********************************

;; ***************************
;; get-work-item-tracking-info
;; ***************************
;; Work items are usually tracked in filed issues to the corresponding repository.
;; Like in my case, most of my work is done in github.com/dotnet/runtime. This little
;; function prompts for the necessary information to record the current work item's
;; Github page, and link to it.

(defun get-work-item-tracking-info ()
  "Prompt for the github repository name and tracking issue number."
  (setq tracking-info "")
  (when (yes-or-no-p "Is there a tracking item in a Github repository? ")

    (let* ((repo-name     (read-string "Enter the Github repository's suburl: "))
           (issue-number  (read-string "Enter the tracking issue number: "))
           (generated-url (format "[[https://github.com/%s/issues/%s]]"
                                  repo-name
                                  issue-number)))

      (setq tracking-info (format "*- Repository: %s*\n*- Issue Number: %s*\n*- Link: %s*"
                                  repo-name
                                  issue-number
                                  generated-url))))

  (when (equal tracking-info "")
    (setq tracking-info "No repository information was provided."))
  (format "%s\n" tracking-info))


;; ***********************
;; get-work-item-checklist
;; ***********************
;; Most work items are usually subdivided by steps or tasks. This little function
;; prompts for said tasks and subtasks, and records them in a checklist format under
;; the current work item's section.

(defun get-work-item-checklist ()
  "Prompt for the initial planned subtasks for the current work item."
  (setq checklist "")
  (when (yes-or-no-p "Do you wish to add checklist items? ")
    (let ((more-tasks t))

      (while more-tasks
        (let* ((task-name (read-string "Enter the next task: "))
               (has-subtasks (yes-or-no-p "Will this task be subdivided into subtasks? "))
               (task-item (if has-subtasks
                              (format "\n- [ ] %s [%%]\n" task-name)
                            (format "\n- [ ] %s\n" task-name))))

          (setq checklist (concat checklist task-item))

          (while has-subtasks
            (let* ((subtask-name (read-string "Enter the subtask: "))
                   (subtask-item (format "  - [ ] %s\n" subtask-name)))

              (setq checklist (concat checklist subtask-item)))
            (setq has-subtasks (yes-or-no-p "Do you wish to add another subtask? "))))
        (setq more-tasks (yes-or-no-p "Do you wish to add another task? ")))))

  (when (equal checklist "")
    (setq checklist "- [ ] Do work item"))
  (format "%s\n" checklist))


;; ******************************
;; get-work-item-capture-template
;; ******************************
;; Main function that is in charge of getting all the capture information for the
;; current work item, format it accordingly, and file it as an org capture template.

(defun get-work-item-capture-template ()
  "Function that entirely generates the org capture template for dotnet work items."
  (let ((job-title       (read-string "Enter the job item title: "))
        (job-description (read-string "Enter the job description: "))
        (job-tags        (read-string "Enter tags for this job item (colon-separated): "))
        (job-repo-info   (get-work-item-tracking-info))
        (job-checklist   (get-work-item-checklist))
        (job-filing-time (format-time-string "%Y/%m/%d %l:%M %P %Z")))

    (format "** NEW ITEM [#2] %s [%%]\n\n:%s:\n:Created: <%s>\n\n%s\n\n%s%s"
            job-title
            job-tags
            job-filing-time
            job-description
            job-repo-info
            job-checklist)))


;; ****************
;; PR Link Template
;; ****************
;; Small template implemented through Emacs' skeletons feature to help writing down
;; the PR information of a work item. See it as a way to include an org template
;; inside another org template, some time after the original one was recorded.

(define-skeleton pr-template
  "Prompt for a Github Pull Request information to add it to a work item."
  ""
  > "*- Pull Request Number: " (setq v1 (skeleton-read "PR Number: ")) "*" \n
  > "*- Link: https://github.com/" (skeleton-read "Repo Suburl: ") "/pull/" v1 "*")


;; *********************
;;  New Item Templates!
;; *********************

;; Since org-mode is for everyone, let's add the dotnet new work item capture
;; templates to emacs' "org-capture-templates", rather than setting it from
;; scratch. We don't want to delete the templates from other org-mode components
;; we might have initialized prior to this one :)

(add-to-list 'org-capture-templates
             '("i" "New Work Item"
               entry (file+headline dotnet-work-todos-file "Work Items")
               #'get-work-item-capture-template
               :empty-lines 1 :immediate-finish t :jump-to-captured t)
             t)

;; **************
;;  Item States!
;; **************

(setq org-todo-keywords
      '((sequence "NEW ITEM(n)"
                  "IN PROGRESS(i!)"
                  "RESEARCHING(r@/!)"
                  "BACKLOGGED(l@/!)"
                  "IN REVIEW(R!)"
                  "BLOCKED(b@/!)"
                  "WARNING(w@/!)"
                  "APPROVED(a!)"
                  "COMPLETE(c!)"
                  "DISCARDED(d@/!)")))

;; ****************
;;  STATES Colors!
;; ****************

(setq org-todo-keyword-faces
      '(("NEW ITEM"    . (:foreground "#005EB8" :weight bold))
        ("IN PROGRESS" . (:foreground "#3BD1B7" :weight bold))
        ("RESEARCHING" . (:foreground "#FB7306" :weight bold))
        ("BACKLOGGED"  . (:foreground "#A348C8" :weight bold))
        ("IN REVIEW"   . (:foreground "#F1C232" :weight bold))
        ("BLOCKED"     . (:foreground "#D13B55" :weight bold))
        ("WARNING"     . (:foreground "#FF1100" :weight bold))
        ("APPROVED"    . (:foreground "#94F29D" :weight bold))
        ("COMPLETE"    . (:foreground "#19D22A" :weight bold))
        ("DISCARDED"   . (:foreground "#A7A7A7" :weight bold))))

;; ************
;;  Item Tags!
;; ************

(setq org-tag-alist
      '(("Coreclr"        . nil)
        ("Infrastructure" . nil)
        ("Libraries"      . nil)
        ("ReadyToRun"     . nil)
        ("Tests"          . nil)))

;; **************
;;  Tags Colors!
;; **************

(setq org-tag-faces
      '(("Coreclr"        . (:foreground "#BE2F42" :weight bold))
        ("Infrastructure" . (:foreground "#00AF99" :weight bold))
        ("Libraries"      . (:foreground "#197CB7" :weight bold))
        ("ReadyToRun"     . (:foreground "#815881" :weight bold))
        ("Tests"          . (:foreground "#D8AE2D" :weight bold))))
