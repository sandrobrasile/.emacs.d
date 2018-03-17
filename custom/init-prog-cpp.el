;;; package --- init-prog-cpp.el
;;; Commentary:
;;; General settings
;;; Code:

;; set style to "bsd", aka Allman
(setq c-default-style "bsd")

;; indent using 2 spaces
(setq-default c-basic-offset 2)

;; prevent indent within namespace
(c-set-offset 'innamespace 0)

;; C++-mode on file open
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.tpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ipp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))

;; Package: irony (C/C++ minor mode powered by libclang)
(use-package irony
  :config
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
)

;; Package: company-irony (completion through company)
(use-package company-irony
  :config
  (global-company-mode)
  ;; (optional) adds CC special commands to `company-begin-commands' in order to
  ;; trigger completion at interesting places, such as after scope operator
  ;;     std::|
  (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
  ;; Remember to create a .clang_complete file in the project root containing the clang flags, i.e.
  ;; -std=c++11
  ;; -Wall
  ;; -Wextra
  ;; -isystem/usr/include/c++/5.4.0/
  ;; -isystem/usr/include/boost/
  ;; -I/home/sandro/src/myproject/include
  ;; ...etc
  )

;; Package: company-irony-c-headers
;; Company-mode backend for C/C++ header files that works with irony-mode.
;; Complementary to company-irony by offering completion suggestions to header files.
(use-package company-irony-c-headers
  :config
  ;; Load with `irony-mode` as a grouped backend
  (eval-after-load 'company
    '(add-to-list
      'company-backends '(company-irony-c-headers company-irony)))
  )

;; Package: flycheck-irony
;; on-the-fly syntax check through flycheck + irony
(use-package flycheck-irony
  :requires (flycheck irony)
  :config
  (eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
  )

;; Package: irony-eldoc
;; For previewing symbol summary/signature in the minibuffer
(use-package irony-eldoc
  :requires irony
  :config
  (add-hook 'irony-mode-hook 'irony-eldoc)
  )

;; Functions for automatically rebuild tags on file save
;;
;; This is a solution for average sized project
;; See: https://www.emacswiki.org/emacs/GnuGlobal
;; (defun gtags-root-dir ()
;;   ;; Returns GTAGS root directory or nil if doesn't exist.
;;   (with-temp-buffer
;;     (if (zerop (call-process "global" nil t nil "-pr"))
;;         (buffer-substring (point-min) (1- (point-max)))
;;       nil)))
;; (defun gtags-update ()
;;   ;; Make GTAGS incremental update
;;   (call-process "global" nil nil nil "-u"))
;; (defun gtags-update-hook ()
;;   (when (gtags-root-dir)
;;     (gtags-update)))
;; (add-hook 'after-save-hook #'gtags-update-hook) ; hook on save
;;
;; Instead, this is a solution for huge projects
;; See: https://www.emacswiki.org/emacs/GnuGlobal
(defun gtags-root-dir ()
  ;; Returns GTAGS root directory or nil if doesn't exist.
  (with-temp-buffer
    (if (zerop (call-process "global" nil t nil "-pr"))
        (buffer-substring (point-min) (1- (point-max)))
      nil)))
(defun gtags-update-single(filename)
  "Update Gtags database for changes in a single file"
  (interactive)
  (start-process "update-gtags" "update-gtags" "bash" "-c"
                 (concat "cd " (gtags-root-dir) " ; gtags --single-update " filename )))
(defun gtags-update-current-file()
  (interactive)
  (defvar filename)
  (setq filename (replace-regexp-in-string (gtags-root-dir) "." (buffer-file-name (current-buffer))))
  (gtags-update-single filename)
  (message "Gtags updated for %s" filename))
(defun gtags-update-hook()
  "Update GTAGS file incrementally upon saving a file"
  (when (gtags-root-dir)
    (gtags-update-current-file)))

;; Package: counsel-gtags
;; For jumping to definitions using tags using ivy + GNU-Global
;; Use this as an alternative to rtags + cmake-ide
;; It requires GNU-Global installed on the system
(use-package counsel-gtags
  :init
  (progn
    (add-hook 'c-mode-hook 'counsel-gtags-mode)
    (add-hook 'c++-mode-hook 'counsel-gtags-mode)

    (setq counsel-gtags-ignore-case t
          counsel-gtags-auto-update t
          counsel-gtags-use-input-at-point t
          counsel-gtags-prefix-key "\C-cg")

    ;; key bindings
    (with-eval-after-load 'counsel-gtags
      (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
      (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
      (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
      (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
      (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward)
      )

    ;; enable tags regeneration on save
    (add-hook 'after-save-hook 'gtags-update-hook)
    ))

;; Package: helm-gtags
;; For jumping to definitions using tags using helm + GNU-Global
;; Use this as an alternative to rtags + cmake-ide
;; It requires GNU-Global installed on the system
(use-package helm-gtags
  :disabled ;; I switched to ivy, so see counsel-gtags
  :init
  (progn
    (setq helm-gtags-ignore-case t
          helm-gtags-auto-update t
          helm-gtags-use-input-at-cursor t
          helm-gtags-pulse-at-cursor t
          helm-gtags-prefix-key "\C-cg"
          helm-gtags-suggested-key-mapping t)

    ;; Enable helm-gtags-mode in Dired so you can jump to any tag
    ;; when navigate project tree with Dired
    (add-hook 'dired-mode-hook 'helm-gtags-mode)

    ;; Enable helm-gtags-mode in Eshell for the same reason as above
    (add-hook 'eshell-mode-hook 'helm-gtags-mode)

    ;; Enable helm-gtags-mode in languages that GNU Global supports
    (add-hook 'c-mode-hook 'helm-gtags-mode)
    (add-hook 'c++-mode-hook 'helm-gtags-mode)
    (add-hook 'java-mode-hook 'helm-gtags-mode)
    (add-hook 'asm-mode-hook 'helm-gtags-mode)

    ;; key bindings
    (with-eval-after-load 'helm-gtags
      (define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
      (define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
      (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
      (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
      (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
      (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history))

    ;; enable tags regeneration on save
    (add-hook 'after-save-hook 'gtags-update-hook)
    )
  )


(provide 'init-prog-cpp)
;;; init-prog-cpp.el ends here
[5~]
