; Hide menu bar
(menu-bar-mode -1)

; Packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defun ensure-package-installed (&rest packages)
  "Ensure every package is installed, ask for installation if it’s not.
   Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (unless (package-installed-p package)
       (package-install package)))
     packages)
  )

(when (not package-archive-contents)
  (package-refresh-contents))

(ensure-package-installed
 'dockerfile-mode
 'fish-mode
 'go-mode
 'magit
 'telephone-line
 'yaml-mode
)

; Edit compressed files
(auto-compression-mode t)

; Don't use tabs for indentation
(setq-default indent-tabs-mode nil) 

; Enable backup files
(setq make-backup-files t)

; Save all backup file in this directory
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

; Start-up messages
(setq initial-scratch-message "")
(setq inhibit-startup-message t)

; yes -> y, no -> n
(fset 'yes-or-no-p 'y-or-n-p)

; Syntax highlights
(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)

; Window keybindings
(windmove-default-keybindings)

; Misc
'(cursor-type . bar)
(setq visible-bell t)
(setq require-final-newline t)

; Telephone line

(require 'telephone-line)
(setq telephone-line-primary-right-separator 'telephone-line-abs-left
      telephone-line-secondary-right-separator 'telephone-line-abs-hollow-left)

(setq telephone-line-height 24)

(telephone-line-mode 1)

; Custom
(setq custom-file "~/.emacs.d/custom.el")

(add-hook 'kill-emacs-query-functions
               'custom-prompt-customize-unsaved-options)

(if (file-exists-p custom-file)
    (load custom-file)
  ; else initialize custom variables
  (custom-set-variables
   '(ansi-color-faces-vector
     [default default default italic underline success warning error])
   '(ansi-color-names-vector
     ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
   '(custom-enabled-themes (quote (tsdh-dark)))
   '(package-selected-packages
     (quote
      (magit yaml-mode telephone-line go-mode fish-mode dockerfile-mode))))
  (custom-set-faces
   )
  )
