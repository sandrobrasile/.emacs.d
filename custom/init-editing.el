;;; package --- init-editing.el
;;; Commentary:
;;; General settings
;;; Code:

;; Package: ace-jump-mode
(use-package ace-jump-mode
  :ensure t
  :config
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
  (define-key global-map (kbd "C-c C-c SPC") 'ace-jump-line-mode)
  )

;; Package: multiple-cursors
(use-package multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

;; Package: undo-tree
(use-package undo-tree
  :init
  ;; turn it on everywhere
  (global-undo-tree-mode 1)
  :config
  ;; make ctrl-z undo
  (global-set-key (kbd "C-z") 'undo)
  ;; make ctrl-Z redo
  (defalias 'redo 'undo-tree-redo)
  (global-set-key (kbd "C-S-z") 'redo)
  )

;; Package: company
(use-package company
  :config
  (global-company-mode)
  (setq company-idle-delay 0)
  )

;; Package: ivy
(use-package ivy
  :init
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key (kbd "C-s") 'swiper)))

;; Package: counsel
(use-package counsel
  :bind
  (("M-x" . counsel-M-x)
   ("M-y" . counsel-yank-pop)
   ("C-c r" . counsel-recentf)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f" . counsel-describe-function)
   ("<f1> v" . counsel-describe-variable)
   ("<f1> l" . counsel-load-library)
   ("C-h f" . counsel-describe-function)
   ("C-h v" . counsel-describe-variable)
   ("C-h l" . counsel-load-library)))

;; shortcut for opening man pages (using helm)
(global-set-key  [f1] (lambda () (interactive) (helm-man-woman (current-word))))

(provide 'init-editing)
;;; init-editing ends here
