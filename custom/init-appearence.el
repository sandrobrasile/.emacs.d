;;; package --- init-appearence.el
;;; Commentary:
;;; General settings
;;; Code:

;; Material theme
(use-package material-theme)
(load-theme 'material t)

;; Zenburn theme
;; (use-package zenburn-theme)
;; (load-theme 'zenburn t)
;; ;; zenburn background color is too dark
;; (setq default-frame-alist
;;       (append default-frame-alist
;;               '((background-color . "color-241")
;;                 )))
;;(set-face-background hl-line-face "color-239")
;;(set-face-background 'linum "color-241")
;;(set-face-foreground 'linum "color-243")

;; Paren mode colors
(use-package paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#ff0000") ; show red parentheses on match
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

(provide 'init-appearence)
;;; init-appearence ends here
