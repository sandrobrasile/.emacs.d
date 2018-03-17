;;; package --- init-general.el
;;; Commentary:
;;; General settings
;;; Code:

;; Garbage collector settings
(setq gc-cons-threshold 100000000)

;; Enable hl-line mode
(global-hl-line-mode)

;; More precise resizing
(setq frame-resize-pixelwise t)

;; Minimalistic Emacs at startup
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-scroll-bar-mode nil)

;; Stop creating backup~ and #autosave# files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Avoid startup message
(setq inhibit-startup-message t)

;; Faster yes-not answers on prompt
(defalias 'yes-or-no-p 'y-or-n-p)

;; Smooth scrolling
(setq scroll-step 1)
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-preserve-screen-position t)

;; Windmove, so that you can move from window to window through SHIFT + Arrow Keys
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings)
  )

(provide 'init-general)
;;; init-general ends here
