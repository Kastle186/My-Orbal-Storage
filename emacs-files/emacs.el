;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(require 'ibuf-ext)

;; Multiple cursors doesn't work on Windows for some reason.
(when (and (not (equal system-type 'windows-nt)) (package-installed-p 'multiple-cursors))
  (require 'multiple-cursors))

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Load my Org-Mode and Ren'py configurations.

(load-file "~/.emacs.d/org-mode-config/my-org-mode-config.el")
(load-file "~/.emacs.d/my-tools/keywords.el")
(load-file "~/.emacs.d/my-tools/utils.el")
(load-file "~/.emacs.d/my-tools/renpy-config.el")
(load-file "~/.emacs.d/my-tools/dotnet-dev-environment.el")

;; Some file extensions use the same syntax as XML. Let Emacs to enable xml-mode
;; by default when editing these types of files.

(add-to-list 'auto-mode-alist '("\\.inl\\'"        . c++-mode))
(add-to-list 'auto-mode-alist '("\\.csproj\\'"     . xml-mode))
(add-to-list 'auto-mode-alist '("\\.ilproj\\'"     . xml-mode))
(add-to-list 'auto-mode-alist '("\\.proj\\'"       . xml-mode))
(add-to-list 'auto-mode-alist '("\\.depproj\\'"    . xml-mode))
(add-to-list 'auto-mode-alist '("\\.sfxproj\\'"    . xml-mode))
(add-to-list 'auto-mode-alist '("\\.bundleproj\\'" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.props\\'"      . xml-mode))
(add-to-list 'auto-mode-alist '("\\.targets\\'"    . xml-mode))

;; Some nice general configuration :)

(setq-default line-number-mode t)
(setq-default column-number-mode t)
(setq-default make-backup-files nil)
(setq-default auto-save-default nil)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default scroll-conservatively most-positive-fixnum)
(setq-default frame-title-format
              '("" "%b%* (%f) %p/%P - GNU Emacs " emacs-version " at " system-name))
(setq-default auth-sources '("~/.authinfo.gpg"))
(setq-default ediff-forward-word-function 'forward-char)
(setq-default delete-selection-mode t)
(setq-default org-confirm-babel-evaluate nil)
(setq-default org-element-use-cache nil)
(setq-default ring-bell-function 'ignore)

;; Enable all the languages I tend to use in Babel by default.

(setq-default org-babel-load-languages
              '((emacs-lisp . t)
                (python     . t)
                (ruby       . t)
                (sed        . t)
                (shell      . t)))

;; Auxiliary functions to boost my productivity!

(defun toggle-line-numbers-type ()
  "Function to easily toggle between normal/absolute and relative line numbering."
  (interactive)
  (if (not (equal display-line-numbers-type 'relative))
      (setq-default display-line-numbers-type 'relative)
    (setq-default display-line-numbers-type 'absolute))
  (display-line-numbers-mode 1))

(windmove-default-keybindings)

;; Useful and Productive Keybindings!

(global-set-key (kbd "C-x x w") 'toggle-word-wrap)
(global-set-key (kbd "C-x x t") 'toggle-truncate-lines)
(global-set-key (kbd "C-x x f") 'menu-set-font)
(global-set-key (kbd "C-<f7>") 'toggle-line-numbers-type)
(global-set-key (kbd "M-n") 'display-line-numbers-mode)
(global-set-key (kbd "C-x C-M-b") 'ibuffer)

;; These keys are just for my rescued keyboard whose 'f' key doesn't work.

;; (global-set-key (kbd "<f5>") "f")
;; (global-set-key (kbd "<f6>") "F")
;; (global-set-key (kbd "C-<f5>") 'forward-char)
;; (global-set-key (kbd "M-<f5>") 'forward-word)
;; (global-set-key (kbd "C-x M-<f5>") 'find-char-forward)
;; (global-set-key (kbd "C-x M-<f6>") 'find-char-backward)
;; (global-set-key (kbd "C-x C-<f5>") 'find-file)
;; (global-set-key (kbd "C-x x <f5>") 'menu-set-font)

;; Text modifying and navigation keyboard shortcuts

(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x E") 'erase-buffer)
(global-set-key (kbd "C-x t h") 'sgml-tag)
(global-set-key (kbd "M-s M-s") 'wrap-region-global-mode)
(global-set-key (kbd "M-s M-r") 'narrow-to-region)
(global-set-key (kbd "M-s M-e") 'widen)
(global-set-key (kbd "C-x M-f") 'find-char-forward)
(global-set-key (kbd "C-x M-F") 'find-char-backward)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "C-M-z") 'zap-to-char)

;; Frame manipulation keyboard shortcuts

(global-set-key (kbd "M-g t") 'transpose-frame)
(global-set-key (kbd "M-g r") 'rotate-frame-clockwise)
(global-set-key (kbd "M-g i") 'flip-frame)
(global-set-key (kbd "M-g o") 'flop-frame)

;; Magit keyboard shortcuts.

(global-set-key (kbd "C-x C-k k") 'magit-kill-this-buffer)
(global-set-key (kbd "C-x M-a") 'magit-blame-addition)
(global-set-key (kbd "C-x M-r") 'magit-blame-removal)

;; Keybindings for easy split windows resizing.

(global-set-key (kbd "C-<up>") 'enlarge-window)
(global-set-key (kbd "C-<down>") 'shrink-window)
(global-set-key (kbd "C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<right>") 'enlarge-window-horizontally)

;; Configured keybindings for multiple cursors mode (Non-Windows only).

(when (and (not (equal system-type 'windows-nt)) (package-installed-p 'multiple-cursors))
  (define-key mc/keymap (kbd "<return>") nil)
  (global-set-key (kbd "C-S-c C-S-n") 'mc/edit-lines)
  (global-set-key (kbd "C-S-j") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-S-k") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click))

;; Quick keybindings for writeroom mode.

(with-eval-after-load 'writeroom-mode
  (define-key writeroom-mode-map (kbd "C-M-=") 'writeroom-adjust-width)
  (define-key writeroom-mode-map (kbd "C-M->") 'writeroom-increase-width)
  (define-key writeroom-mode-map (kbd "C-M-<") 'writeroom-decrease-width))

;; It's really annoying to have Emacs GUI minimized with an accidental typo :(

(when (display-graphic-p)
  (global-unset-key (kbd "C-z"))
  (global-unset-key (kbd "C-x C-z")))

;; I seldom use the screen scroll shortcuts, and they're constantly getting on
;; my nerves due to accidental typos :(

(global-unset-key (kbd "C-v"))
(global-unset-key (kbd "M-v"))

;; Reuse Dired buffer also when moving back up to parent folder.

(add-hook 'dired-mode-hook
          (lambda () (define-key dired-mode-map (kbd "^")
                       (lambda () (interactive) (find-alternate-file "..")))))

;; The Emacs' default C-styles don't quite match my tastes, so change them to the
;; default linux ones. But only for C/C++ files because for other languages like C#,
;; the Emacs' default styles fit my tastes best. Also, add the extra keywords I've
;; defined for each of the languages :)

(add-hook 'emacs-lisp-mode-hook
          (lambda () (font-lock-add-keywords 'emacs-lisp-mode my-elisp-keywords)))

(add-hook 'lisp-interaction-mode-hook
          (lambda () (font-lock-add-keywords 'lisp-interaction-mode my-elisp-keywords)))

(add-hook 'c-mode-hook
          (lambda () (progn
                       (c-set-style "linux")
                       (setq c-basic-offset 4)
                       (setq indent-tabs-mode nil)
                       (font-lock-add-keywords 'c-mode my-c-language-keywords))))

(add-hook 'c++-mode-hook
          (lambda () (progn
                       (c-set-style "linux")
                       (setq c-basic-offset 4)
                       (setq indent-tabs-mode nil)
                       (font-lock-add-keywords 'c++-mode my-c++-keywords))))

(add-hook 'erlang-mode-hook
          (lambda () (font-lock-add-keywords 'erlang-mode my-erlang-keywords)))

(add-hook 'js-mode-hook
          (lambda () (font-lock-add-keywords 'js-mode my-js-keywords)))

(add-hook 'julia-mode-hook
          (lambda () (font-lock-add-keywords 'julia-mode my-julia-keywords)))

(add-hook 'python-mode-hook
          (lambda () (font-lock-add-keywords 'python-mode my-python-keywords)))

(add-hook 'ruby-mode-hook
          (lambda () (font-lock-add-keywords 'ruby-mode my-ruby-keywords)))

(add-hook 'sh-mode-hook
          (lambda () (font-lock-add-keywords 'sh-mode my-shell-keywords)))

;; Grouping buffers by category in IBuffer makes my life so much easier
;; and productive :)

(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("Bash/Shell" (mode . sh-mode))
               ("C"          (mode . c-mode))
               ("C++"        (mode . c++-mode))
               ("CSV"        (name . "\\.csv"))
               ("Elisp"      (mode . emacs-lisp-mode))
               ("JSON"       (mode . json-mode))
               ("Julia"      (mode . julia-mode))
               ("Lua"        (mode . lua-mode))
               ("Markdown"   (mode . markdown-mode))
               ("Org"        (mode . org-mode))
               ("Python"     (or
                              (mode . python-mode)
                              (name . "^\\*Python\\*$")))
               ("Ruby"       (or
                              (mode . ruby-mode)
                              (mode . inf-ruby-mode)))
               ("Rust"       (mode . rust-mode))
               ("Swift"      (mode . swift-mode))
               ("Text"       (mode . text-mode))
               ("XML"        (mode . xml-mode))
               ("YAML"       (mode . yaml-mode))
               ("Terminals"  (mode . term-mode))
               ("Dired"      (mode . dired-mode))
               ("Magit"      (name . "magit*"))
               ("TAGS"       (or
                              (mode . tags-table-mode)
                              (name . "^\\*Tags List\\*$")))
               ("Emacs"      (or
                              (mode . Buffer-menu-mode)
                              (mode . grep-mode)
                              (mode . help-mode)
                              (name . "^\\*scratch\\*$")
                              (name . "^\\*Async-native-compile-log\\*$")
                              (name . "^\\*Backtrace\\*$")
                              (name . "^\\*Compile-Log\\*$")
                              (name . "^\\*Completions\\*$")
                              (name . "^\\*GNU Emacs\\*$")
                              (name . "^\\*Messages\\*$")
                              (name . "^\\*Occur\\*$")
                              (name . "^\\*Packages\\*$")
                              (name . "^\\*Warnings\\*$")))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

;; However, I prefer to only see the categories that have buffers open.

(setq-default ibuffer-show-empty-filter-groups nil)

;; I also prefer to have the human-readable notations for buffer sizes, rather than
;; all bytes-only.

(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.2f MB" (/ (buffer-size) 1000000.0)))
   ((> (buffer-size) 1000)    (format "%7.2f KB" (/ (buffer-size) 1000.0)))
   (t (format "%8d" (buffer-size)))))

(setq ibuffer-formats
      '((mark modified read-only
              " "
              (name 20 20 :left :elide)
              " "
              (size-h 11 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              filename-and-process)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#282b33" "#e1c1ee" "#5b94ab" "#cfcf9c" "#819cd6" "#a6c1e0" "#7289bc" "#c6c6c6"])
 '(column-number-mode t)
 '(cursor-type 'box)
 '(custom-enabled-themes '(deeper-blue))
 '(display-time-mode t)
 '(frame-background-mode 'dark)
 '(menu-bar-mode t)
 '(package-selected-packages
   '(rust-mode swift-mode ubuntu-theme treemacs-icons-dired treemacs-all-the-icons grep-a-lot markdown-mode writeroom-mode json-mode org-bullets evil tool-bar+ dot-mode multiple-cursors julia-mode doom-themes wrap-region vimrc-mode transpose-frame vscode-dark-plus-theme lua-mode magit yaml-mode cmake-mode dockerfile-mode twilight-anti-bright-theme badwolf-theme clues-theme soothe-theme flatui-dark-theme subatomic-theme tangotango-theme afternoon-theme kaolin-themes gruber-darker-theme alect-themes apropospriate-theme ample-theme cyberpunk-theme moe-theme material-theme dracula-theme gruvbox-theme monokai-theme spacemacs-theme color-theme-modern color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized zenburn-theme treemacs))
 '(scroll-bar-mode nil)
 '(size-indication-mode t)
 '(tool-bar-mode t)
 '(warning-suppress-types '((comp) (comp) (comp)))
 '(window-divider-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(term-color-black ((t (:foreground "#555753"))))
 '(term-color-blue ((t (:foreground "#729FCF"))))
 '(term-color-cyan ((t (:foreground "#34E2E2"))))
 '(term-color-green ((t (:foreground "#8AE234"))))
 '(term-color-magenta ((t (:foreground "#AD7FA8"))))
 '(term-color-red ((t (:foreground "#EF2929"))))
 '(term-color-white ((t (:foreground "#EEEEEC"))))
 '(term-color-yellow ((t (:foreground "#FCE94F"))))
 '(term-default-bg-color ((t (:inherit term-color-black))))
 '(term-default-fg-color ((t (:inherit term-color-white)))))

;; Advanced functionality I need.

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
