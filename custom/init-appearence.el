;;; package --- init-appearence.el
;;; Commentary:
;;; General settings
;;; Code:

;; Zenburn theme
(use-package zenburn-theme)
(load-theme 'zenburn t)
(with-eval-after-load "zenburn-theme"
  (zenburn-with-color-variables
    (custom-theme-set-faces
     'zenburn
     `(region ((t (:background ,zenburn-bg+3))(t :inverse-video t)))
     )))

;; Paren mode colors
(use-package paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#ff0000") ; show red parentheses on match
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

(provide 'init-appearence)
;;; init-appearence ends here
