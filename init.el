;;; package --- init.el
;;; Commentary:
;;; Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic behaviour and appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq custom-file "~/.emacs-custom.el")
(if (file-exists-p custom-file)(load custom-file) nil )

;; Enable hl-line mode
(global-hl-line-mode)

;; linum-mode
(global-linum-mode 1)

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
(setq linum-format "%4d \u2502") ; changes the format putting a space before text and a vertical line

;; More precise resizing
(setq frame-resize-pixelwise t)

;; Parentheses match
(use-package paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#ff0000") ; show red parentheses on match
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

(set-face-background 'vertical-border "color-235")
(set-face-foreground 'vertical-border (face-background 'vertical-border))
;; Set symbol for the border
;; (set-display-table-slot standard-display-table
;;                        'vertical-border (make-glyph-code ?│))

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

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook
          (lambda () (interactive)
            (setq show-trailing-whitespace 1)))

;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; Use TAB to indent or complete
;; First TAB is indent, second TAB is completion
;; Should the indentation be already correct, then is completion right away
(setq tab-always-indent 'complete)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)
(setq-default c-basic-offset 2)

(show-paren-mode 1)
(setq column-number-mode t)

;;; Smooth scrolling
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

;; Garbage collector settings
(setq gc-cons-threshold 100000000)

;; Multiple cursors
(use-package multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo-tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undo-tree)
;; turn on everywhere
(global-undo-tree-mode)
;; make ctrl-z undo
(global-set-key (kbd "C-z") 'undo)
;; make ctrl-Z redo
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-S-z") 'redo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; styles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; set style to "bsd", aka Allman
(setq c-default-style "bsd")

(c-set-offset 'innamespace 0) ; prevent indent within namespaceb

;; show the 80th column marker (on as a needed basis enabling whitespace-mode)
(use-package whitespace
  :config
  (setq-default whitespace-line-column 80
                whitespace-style '(face lines-tail)
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; major modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.tpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ipp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))

;; CMake
(use-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
  :init (setq cmake-tab-width 4)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; minor modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hs minor mode, useful for folding and hiding block of text
(add-hook 'c-mode-common-hook   'hs-minor-mode)
;; C-c @ C-c   Toggle hiding/showing of a block
;; C-c @ C-h   Select current block at point and hide it
;; C-c @ C-l   Hide all block with indentation levels below this block
;; C-c @ C-s   Select current block at point and show it
;; C-c @ C-M-h Hide all top level blocks, displaying only first and last lines
;; C-c @ C-M-s Show everything
;; smartparens
(use-package smartparens
  :config
  (show-smartparens-global-mode +1)
  (smartparens-global-mode 1)
  ;; when you press RET, the curly braces automatically add another newline
  (sp-with-modes '(c-mode c++-mode)
                 (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
                 (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                                           ("* ||\n[i]" "RET"))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet, a template system for emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yasnippet-snippets
  :config
  (yas-global-mode 1)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Not used, since it works with .json files, and this excluds headers-only projects
;; I use Gnu Global + helm-gtags
;;
;; Eventually, I would use rtags only for navigation and refactoring
;; (use-package rtags
;;   :config
;;   ;; Set path to rtag executables if needed.
;;   ;; (setq rtags-path (expand-file-name "~/opensource/rtags/build"))
;;   ;;
;;   ;; Start the rdm process unless the process is already running.
;;   (rtags-start-process-unless-running)
;;   ;;
;;   ;; Enable rtags-diagnostics.
;;   (setq rtags-autostart-diagnostics t)
;;   (rtags-diagnostics)
;;   ;;
;;   ;; Timeout for reparse on onsaved buffers.
;;   (rtags-set-periodic-reparse-timeout 0.5)
;;   ;;
;;   ;; Rtags standard keybindings ([M-. on symbol to go to bindings]).
;;   (rtags-enable-standard-keybindings)
;;   )

;; I use Irony for code completion
;;(use-package company-rtags
;;  :after rtags company
;;  :config
;;  (push 'company-rtags company-backends) ; Add company-rtags to company-backends
;;  (setq rtags-completions-enabled t)
;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cmake ide
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Not used, since there is no advantage when implementing headers-only projects
;; Eventually, uncomment along with rtags
;; (use-package cmake-ide
;;   :after rtags
;;   :config
;;   ;; set path to project build directory
;;   ;;(setq cmake-ide-build-dir
;;   ;;      (expand-file-name "~/src/sandro/build"))
;;   ;; CURRENTLY: hardcode to build dir of default project
;;   ;; Create/use a .dir-locals.el such as
;;   ;; ((nil . (
;;   ;;     (cmake-ide-build-dir . "/home/sandro/src/my-project/build/debug")
;;   ;;     )))

;;   ;; invoke cmake-ide setup
;;   (cmake-ide-setup)
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; irony (C/C++ minor mode powered by libclang) and company for completions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;; Company mode
(use-package company
  :config (global-company-mode)
  )

;; company-irony
(use-package company-irony
  :after company
  :config (global-company-mode)
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
(setq company-idle-delay 0)

;; Company-mode backend for C/C++ header files that works with irony-mode.
;; Complementary to company-irony by offering completion suggestions to header files.
(use-package company-irony-c-headers
  :after company-irony
  :config
  ;; Load with `irony-mode` as a grouped backend
  (eval-after-load 'company
    '(add-to-list
      'company-backends '(company-irony-c-headers company-irony)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package flycheck
  :init (global-flycheck-mode)
  )

;; Color mode line for errors.
(use-package flycheck-color-mode-line
  :after flycheck
  :config '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
  )

;; Show pos-tip popups for errors.
(use-package flycheck-pos-tip
  :after flycheck
  :config (flycheck-pos-tip-mode)
  )

;; Flycheck rtags: I use irony for code auto complete
;;(use-package flycheck-rtags
;;  :ensure t
;;  :after flycheck rtags
;;  :config
;;  (defun my-flycheck-rtags-setup ()
;;    (flycheck-select-checker 'rtags)
    ;;    (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
    ;;    (setq-local flycheck-check-syntax-automatically nil)
;;    )
;;  (add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
;;  (add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
;;  )

(use-package flycheck-irony
  :config
  (eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; irony-eldoc, for previewing symbol summary/signature in the minibuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package irony-eldoc
  :config
  (add-hook 'irony-mode-hook 'irony-eldoc)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gdb many windows layout support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sr-speedbar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package sr-speedbar)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm-gtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For jumping to definitions using tags, in alternative to rtags + cmake-ide
;; It requires GNU-Global installed on the system
(use-package helm-gtags
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
    )

  ;; Automatically rebuild tags on file save
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
  ;; They say this is a solution for huge projects
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
    (start-process "update-gtags" "update-gtags" "bash" "-c" (concat "cd " (gtags-root-dir) " ; gtags --single-update " filename )))
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
    (add-hook 'after-save-hook 'gtags-update-hook)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy-counsel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ivy
  :init
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key (kbd "C-s") 'swiper)))

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

(use-package counsel-projectile
  :init
  (counsel-projectile-mode)
  ;; It is advisable to create a .projectile file in the root dir of the project
  ;; See https://github.com/bbatsov/projectile
  ;;     https://github.com/ericdanan/counsel-projectile
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ecb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ecb
  :config
  (setq ecb-layout-name "left15") ; it has directory + symbols on the left
  ;; Show the files in the directory tree too, so that we don't need a source buffer
  (setq ecb-show-sources-in-directories-buffer '("left3" "left7" "left13" "left14" "left15"))
  ;;(setq ecb-use-speedbar-instead-native-tree-buffer 'dir)
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format can be triggered using C-M-tab
;;(use-package clang-format
;;  :config (global-set-key [C-M-tab] 'clang-format-region)
;;  )

;; If the repo does not have a .clang-format files, one can
;; be created using google style:
;; clang-format -style=google -dump-config > .clang-format
;; In this, default indent is 2 (see 'IndentWidth' key in generated file).

;; shortcut for opening man pages (using helm)
(global-set-key  [f1] (lambda () (interactive) (helm-man-woman (current-word))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The End
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init)
;;; init.el ends here
