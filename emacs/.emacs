; Hide menu bar
(menu-bar-mode -1)

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

; syntax highlights
(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)

'(cursor-type . bar)
(setq visible-bell t)

(setq require-final-newline t)

;; Show line-number in the mode line
;(global-linum-mode t)
;; Show column-number in the mode line
;(column-number-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (tsdh-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
