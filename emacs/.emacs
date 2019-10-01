                                        ; Hide menu bar
(menu-bar-mode -1)

                                        ; Packages
(require 'package)


(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
	("MELPA Stable" . "https://stable.melpa.org/packages/")
	("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("MELPA Stable" . 10)
	("GNU ELPA"     . 5)
	("MELPA"        . 0)))

;(add-to-list 'package-archives
;	     '("melpa" . "http://melpa.org/packages/") t)
;(add-to-list 'package-archives
;             '("marmalade" . "http://marmalade-repo.org/packages/"))
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
 'base16-theme
 'dockerfile-mode
 'fish-mode
 'go-mode
 'magit
 'neotree
 'powerline
 'rainbow-mode
 'rust-mode
 'yaml-mode
 )

                                        ; Theme
(load-theme 'base16-twilight t)

                                        ; Status line
(require 'powerline)
(powerline-default-theme)

                                        ; Show line numbers
;(global-display-line-numbers-mode)
(global-linum-mode t)

                                        ; Edit compressed files
(auto-compression-mode t)

                                        ; Configure indentation
(setq-default indent-tabs-mode nil)
(electric-indent-mode 0)

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

                                        ; Fix tmux xterm-keys
(defadvice terminal-init-screen
  ;; The advice is named `tmux', and is run before `terminal-init-screen' runs.
  (before tmux activate)
  ;; Docstring.  This describes the advice and is made available inside emacs;
  ;; for example when doing C-h f terminal-init-screen RET
  "Apply xterm keymap, allowing use of keys passed through tmux."
  ;; This is the elisp code that is run before `terminal-init-screen'.
  (if (getenv "TMUX")
    (let ((map (copy-keymap xterm-function-map)))
    (set-keymap-parent map (keymap-parent input-decode-map))
    (set-keymap-parent input-decode-map map))))

                                        ; Misc
'(cursor-type . bar)
(setq visible-bell t)
(setq require-final-newline t)

                                        ; Magit
(global-set-key (kbd "C-x g") 'magit-status)

                                        ; Custom
(setq custom-file "~/.emacs.d/custom.el")

(add-hook 'kill-emacs-query-functions
               'custom-prompt-customize-unsaved-options)

(if (file-exists-p custom-file)
    (load custom-file)
  ; else initialize custom variables
  (custom-set-variables
   '(package-selected-packages
     (quote
      (magit yaml-mode go-mode fish-mode dockerfile-mode))))
  )
(put 'dired-find-alternate-file 'disabled nil)
