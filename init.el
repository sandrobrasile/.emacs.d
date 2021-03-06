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

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'init-general)
(require 'init-appearence)
(require 'init-editing)
(require 'init-prog-general)
(require 'init-prog-cpp)

(setq custom-file "~/.emacs-custom.el")
(if (file-exists-p custom-file)(load custom-file) nil )

(use-package org)
(use-package graphviz-dot-mode)
(setq org-src-fontify-natively t)
;; List of languages that may be evaluated in Org documents
(setq org-babel-load-languages
      '((emacs-lisp . t)
        (python .t)
        (plantuml . t)
        (dot . t)))
(org-babel-do-load-languages 'org-babel-load-languages
                             org-babel-load-languages)

(add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))

;; To see key stroke suggestions in the minibuffer
(use-package which-key
  :config
  (which-key-mode)
  )

(provide 'init)
;;; init.el ends here
