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
 'base16-theme
 'dockerfile-mode
 'fish-mode
 'go-mode
 'magit
 'powerline
 'rainbow-mode
 'yaml-mode
 )

                                        ; Theme
(load-theme 'base16-twilight t)


                                        ; Status line
(require 'powerline)

(defface powerline-active3 '((t (:background "grey40" :foreground "white" :inherit mode-line)))
  "Powerline face 3.")

(defface powerline-inactive3
  '((t (:background "grey20" :inherit mode-line-inactive)))
  "Powerline face 3.")

(defun powerline-custom-theme ()
  "Setup the custom mode-line."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line-buffer-id (if active 'mode-line-buffer-id 'mode-line-buffer-id-inactive))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face0 (if active 'powerline-active0 'powerline-inactive0))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active3 'powerline-inactive3))
                          (separator-left (intern (format "powerline-%s-%s"
                                                          (powerline-current-separator)
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           (powerline-current-separator)
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list (powerline-raw "%*" face0 'l)
                                     (when powerline-display-buffer-size
                                       (powerline-buffer-size face0 'l))
                                     (when powerline-display-mule-info
                                       (powerline-raw mode-line-mule-info face0 'l))
                                     (powerline-buffer-id `(mode-line-buffer-id ,face0) 'l)
                                     (when (and (boundp 'which-func-mode) which-func-mode)
                                       (powerline-raw which-func-format face0 'l))
                                     (powerline-raw " " face0)
                                     (funcall separator-left face0 face1)
                                     (when (and (boundp 'erc-track-minor-mode) erc-track-minor-mode)
                                       (powerline-raw erc-modified-channels-object face1 'l))
                                     (powerline-major-mode face1 'l)
                                     (powerline-process face1)
                                     (powerline-minor-modes face1 'l)
                                     (powerline-narrow face1 'l)
                                     (powerline-raw " " face1)
                                     (funcall separator-left face1 face2)
                                     (powerline-vc face2 'r)
                                     (when (bound-and-true-p nyan-mode)
                                       (powerline-raw (list (nyan-create)) face2 'l))))
                          (rhs (list (powerline-raw global-mode-string face2 'r)
                                     (funcall separator-right face2 face1)
                                     (powerline-raw "%4l" face1 'l)
                                     (powerline-raw ":" face1 'l)
                                     (powerline-raw "%3c" face1 'r)
                                     (funcall separator-right face1 face0)
                                     (powerline-raw " " face0)
                                     (powerline-raw "%6p" face0 'r)
                                     (when powerline-display-hud
                                       (powerline-hud face0 face2))
                                     (powerline-fill face0 0)
                                     )))
                     (concat (powerline-render lhs)
                             (powerline-fill face2 (powerline-width rhs))
                             (powerline-render rhs)))))))


(powerline-custom-theme)

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
