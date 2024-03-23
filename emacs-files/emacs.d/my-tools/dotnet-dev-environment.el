;; ******************************
;; Dotnet Development Environment
;; ******************************

;; There are some things, like environment variables storing path shortcuts, that make
;; my workflow for dotnet development much lighter on certain path traversing and
;; commands. I already have a "dotnet-dev-environment.sh" script for terminal usage,
;; so now I need one to set up my Emacs with those same utilities. This is the purpose
;; of this little file.

(defun dotnet-dev ()
  "Prompt for the paths of the current runtime repository to set the environment
shortcuts for this Emacs instance."
  (interactive)
  (let ((repo (read-file-name "Enter the path of the runtime repo clone you're working on: "))
        (os (read-string "Enter the OS you're working on (default: linux): "))
        (arch (read-string "Enter the architecture you're working on (default: x64): "))
        (config (read-string "Enter the build configuration you're working on(default: release): ")))

    (unless (file-directory-p repo)
      (error (format "The path %s was not able to be found :(" repo)))

    (when (equal os "") (setq os "linux"))
    (when (equal arch "") (setq arch "x64"))
    (when (equal config "") (setq config "release"))

    (setenv "REPO_ROOT" repo)
    (setenv "TEST_SRC" (format "%s/src/tests" (getenv "REPO_ROOT")))

    (setenv "TEST_ARTIFACTS" (format "%s/artifacts/tests/coreclr/%s.%s.%s"
                                     (getenv "REPO_ROOT") os arch (capitalize config)))

    (setenv "CORE_ROOT" (format "%s/Tests/Core_Root" (getenv "TEST_ARTIFACTS")))

    (setenv "ARCHITECTURE" arch)
    (setenv "CONFIGURATION" config)
    (setenv "OPERATING_SYSTEM" os)))

(defun clean-tests ()
  "Delete the artifacts/tests and artifacts/log directories in the repo path set
by dotnet-dev() previously called."
  (interactive)
  (delete-directory (format "%s/artifacts/tests" (getenv "REPO_ROOT")) t)
  (delete-directory (format "%s/artifacts/log" (getenv "REPO_ROOT")) t))

(defun clean-logs-only ()
  "Delete the artifacts/log directory in the repo path set by dotnet-dev()
previously called."
  (interactive)
  (delete-directory (format "%s/artifacts/log" (getenv "REPO_ROOT")) t))

(defun cd-to-repo-root ()
  "Set Emacs' working directory to the current dotnet-dev repository root path."
  (interactive)
  (cd (getenv "REPO_ROOT")))

(define-skeleton msbuild-message-template
  "Generate a <Message /> tag for an XML MSBuild file. Includes an empty placeholder
for the message, and a given set priority."
  ""
  > "<Message Text=\"\" Importance=\"" (skeleton-read "Enter the message's priority: ") "\" />")
