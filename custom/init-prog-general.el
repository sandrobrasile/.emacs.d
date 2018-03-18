;;; package --- init-prog-general.el
;;; Commentary:
;;; General settings
;;; Code:

;; set appearance of a tab that is represented by 4 spaces
(add-hook 'prog-mode-hook
          (lambda () (interactive)
            ;; use space to indent by default
            (setq-default indent-tabs-mode nil)
            ;; set appearance of a tab that is represented by 4 spaces
            (setq-default tab-width 4)
            ;; Enable matching parentheses feedback
            (show-paren-mode 1)
            ;; Show column numbers
            (setq column-number-mode t)
            ;; show unncessary whitespace that can mess up your diff
            (setq show-trailing-whitespace 1)
            ;; activate whitespace-mode to view all whitespace characters
            (global-set-key (kbd "C-c w") 'whitespace-mode)
            ;; Use TAB to indent or complete
            ;;... First TAB is indent, second TAB is completion
            ;;... Should the indentation be already correct, then is completion right away
            (setq tab-always-indent 'complete)
            ;; linum-mode
            (linum-mode 1)
            ;;... changes the format putting a space before text and a vertical line
            (setq linum-format "%4d \u2502")
            ;; hs minor mode, useful for folding and hiding block of text
            ;;... C-c @ C-c   Toggle hiding/showing of a block
            ;;... C-c @ C-h   Select current block at point and hide it
            ;;... C-c @ C-l   Hide all block with indentation levels below this block
            ;;... C-c @ C-s   Select current block at point and show it
            ;;... C-c @ C-M-h Hide all top level blocks, displaying only first and last lines
            ;;... C-c @ C-M-s Show everything
            (hs-minor-mode 1)
            ))

;; gdb many windows layout support
(setq
  ;; use gdb-many-windows by default
  gdb-many-windows t
  ;; Non-nil means display source file containing the main routine at startup
  gdb-show-main t
  )

;; Package: magit
(use-package magit
  :ensure t
  )

;; Package: cmake-mode
(use-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
  :init (setq cmake-tab-width 4)
  )

;; Package: counsel-projectile
;; Projectile support for using ivy as completion system
(use-package counsel-projectile
  :init
  (counsel-projectile-mode)
  ;; It is advisable to create a .projectile file in the root dir of the project
  ;; See https://github.com/bbatsov/projectile
  ;;     https://github.com/ericdanan/counsel-projectile
  )

;; Package: whitespace
;; shows the 80th column marker (on as a needed basis enabling whitespace-mode)
(use-package whitespace
  :config
  (setq-default whitespace-line-column 80
                whitespace-style '(face lines-tail)
  ))

;; Package: smartparens
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

;; Package: yasnippet-snippets
(use-package yasnippet-snippets
  :config
  (yas-global-mode 1)
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets" ;; my personal snippets
          ))
)

;; Package: flycheck
;; on-the-fly syntax checing
(use-package flycheck
  :init (global-flycheck-mode)
  )

;; Package: flycheck-color-mode-line
(use-package flycheck-color-mode-line
  :after flycheck
  :config '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
  )

;; Package: flycheck-pos-tip
(use-package flycheck-pos-tip
  :after flycheck
  :config (flycheck-pos-tip-mode)
  )

;; Package: sr-speedbar
(use-package sr-speedbar)

;; Package: ecb
(use-package ecb
  :disabled ;; I don't get used to it, I prefer to use projectile
  :config
  (setq ecb-layout-name "left15") ; it has directory + symbols on the left
  ;; Show the files in the directory tree too, so that we don't need a source buffer
  (setq ecb-show-sources-in-directories-buffer '("left3" "left7" "left13" "left14" "left15"))
  ;;(setq ecb-use-speedbar-instead-native-tree-buffer 'dir)
 )

(provide 'init-prog-general)
;;; init-prog-general.el ends here
