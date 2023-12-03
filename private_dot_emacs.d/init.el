;;; Package --- Summary:
;;; Commentary:
;;; Code:

;; -----------------------------------------------------------------------------
;; =                          Package Management
;; -----------------------------------------------------------------------------
;; straight & use-package
;; -----------------------------------------------------------------------------
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(eval-when-compile (require 'use-package))
(straight-use-package 'diminish)
(straight-use-package 'bind-key)
(setq straight-use-package-by-default t)
(setq use-package-always-ensure t)
;; -----------------------------------------------------------------------------
;; / Package Management
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; Performance settings
;; -----------------------------------------------------------------------------
;; recommended by LSP mode
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; -----------------------------------------------------------------------------
;; # Kitty Keyboard Protocol (mainly for supporting super on the terminal)
;;   https://github.com/benjaminor/kkp
;; -----------------------------------------------------------------------------
(use-package kkp
  :config
  (global-kkp-mode +1))

;; -----------------------------------------------------------------------------
;; # Appearance & Themes
;; -----------------------------------------------------------------------------
;; Configure tab-bar-mode
(setq tab-bar-format '(tab-bar-format-history tab-bar-format-tabs tab-bar-separator))
(setq tab-bar-close-button-show nil)
;; If the tab separator is nil then we lose the padding on the tab text, i.e. we
;; need a separator or there is no padding before the tab text, which looks
;; particularly bad on the active tab
(setq tab-bar-separator " ")
;; This advice prevents skips adding the separator before the first tab, preventing
;; an ugly gap before the first tab.
(advice-add 'tab-bar-format-tabs :around
			(lambda (orig-fun)
			  (cdr (funcall orig-fun))))


;; Configure themes
(use-package catppuccin-theme)
;;(setq catppuccin-flavor 'frappe)
;;(use-package rebecca-theme)
;;(use-package zenburn-theme)
;;(use-package shades-of-purple-theme)
;;(use-package borland-blue-theme)
(if (or (display-graphic-p) (daemonp))
	;; (progn
	;;   (use-package green-phosphor-theme
	;; 	:straight
	;; 	(green-phosphor-theme
	;; 	 :type git :host github :repo "aalpern/emacs-color-theme-green-phosphor"
	;; 	 :fork (:host github :repo "jsm3031/emacs-color-theme-green-phosphor"))
	;; 	:defines (green-phosphor-tab-font)
	;; 	:config
	;; 	(setq green-phosphor-tab-font "Roboto Condensed")
	;; 	(load-theme 'green-phosphor t)
	;; 	(tab-bar-mode)))
    (load-theme 'catppuccin t)
    ;;(load-theme 'shades-of-purple t)
    ;;(load-theme 'whiteboard)
    ;;(load-theme 'tango-dark)
    ;;(load-theme 'wombat t)
    ;;(load-theme 'zenburn t)
  (setq frame-background-mode 'dark))

;; (add-hook 'find-file-hook #'(lambda () (put-text-property 1 (point-max) 'line-height '(1.25 1.25))))

;;(use-package rainbow-delimiters)

;; -----------------------------------------------------------------------------
;; / Themes
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Treemacs
;; -----------------------------------------------------------------------------
(use-package treemacs
  :defer t
  :config
  ;;(set-face-attribute 'treemacs-window-background-face nil :family "Roboto Condensed")
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x T 1"   . treemacs-delete-other-windows)
        ("C-x T t"   . treemacs)
        ("C-x T d"   . treemacs-select-directory)
        ("C-x T B"   . treemacs-bookmark)
        ("C-x T C-t" . treemacs-find-file)
        ("C-x T M-t" . treemacs-find-tag)
		("C-x T p"   . treemacs-projectile)))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :functions (treemacs-set-scope-type)
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :config (treemacs-set-scope-type 'Perspectives))

;; (use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
;;   :after (treemacs)
;;   :config (treemacs-set-scope-type 'Tabs))
;; -----------------------------------------------------------------------------
;; / Treemacs
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Shell & Path
;; -----------------------------------------------------------------------------
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  (when (daemonp)
    (exec-path-from-shell-initialize)))
;; -----------------------------------------------------------------------------
;; / Shell & Path
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Basic Emacs Setup
;; -----------------------------------------------------------------------------
;; ## Settings
;; -----------------------------------------------------------------------------
;; The ever-important font choice
;;(set-frame-font "Iosevka Term SS04 Medium 16" nil t)
;;(set-frame-font "Dank Mono 16" nil t)
;;(set-frame-font "JetBrains Mono 13" nil t)
;; Save the minibuffer history
(savehist-mode 1)
;; Set a directory for backups
(setq backup-directory-alist '((".*" . "~/.emacs.d/backups")))
;; Set a directory for autosaves
(setq auto-save-file-name-transforms '((".*"  "~/.emacs.d/backups/" t)))
;; Don't show the emacs start screen
(setq inhibit-startup-screen t)
;; Only answer 'y' ir 'n'
(fset 'yes-or-no-p 'y-or-n-p)
;; Show column (or don't)
(column-number-mode -1)
;; Insert pairs of {}, (), [], etc.
(electric-pair-mode +1)
;; Highlight the matching pairs
(show-paren-mode +1)
;; Save the bookmarks every time they are changed
(setq bookmark-save-flag 1)
;; Make window arrangements undo-able
(winner-mode +1)
;; Navigate to othew windows by holding a modifier key
(windmove-default-keybindings 'control)
;; Period and single space ends sentence (not double space)
(setq sentence-end-double-space nil)
;; disable the stupid bell
(setq ring-bell-function 'ignore)
;; Prevent always asking if it is OK to follow a symlink
(setq vc-follow-symlinks t)
;; Turn line wrapping off by default
(toggle-truncate-lines -1)
;; Show line numbers in large files
(setq line-number-display-limit nil)
;; Max width for line number display
;;(setq line-number-display-limit-width nil)
;; Automatically refresh when buffer is changed on disk, if unmodified
(global-auto-revert-mode nil)
;; TODO setup recentf-mode properly
(recentf-mode 1)
;;(setq recentf-max-menu-items 25)
;;(setq recentf-max-saved-items 25)
;;(global-set-key (kbd "C-x R") 'recentf-open-files)
(setq-default tab-width 4)
;; Due to my incessant keyboard layout changes
(setq echo-keystrokes 0.1)
;;;;(vc-mode-line nil) ;; hide the git branch *add to prog mode hook*
;; This option forces all non-manual splits (magit, compile) to be horizontal
(setq split-width-threshold nil)

;;(setq-default line-spacing 0.3)
;; -----------------------------------------------------------------------------
;; ## Key Bindings
;; -----------------------------------------------------------------------------
(global-set-key (kbd "C-c B")  'ibuffer)
(global-set-key (kbd "M-s-k")  'kill-current-buffer)
(global-set-key (kbd "<C-f6>") 'hl-line-mode)
(global-set-key (kbd "<C-f7>") 'display-line-numbers-mode)
(global-set-key (kbd "<C-f8>") 'auto-revert-mode)
(global-set-key (kbd "C-M-z")  'zap-up-to-char)
(global-set-key (kbd "C-z")    'undo-tree-undo)
(global-set-key (kbd "C-S-z")  'undo-tree-redo)
(global-set-key (kbd "C-S-<left>")  'previous-buffer)
(global-set-key (kbd "C-S-<right>") 'next-buffer)
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-x K") 'kill-buffer)
;; ------------------------------------------------------------------------------------------------------------------
;; / Basic Emacs Setup
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Functions
;; -----------------------------------------------------------------------------
(defun jsm/file-path ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(defun jsm/zshrc ()
  "Open the Zshrc init file."
  (interactive)
  (find-file "~/.zshrc"))

(defun jsm/sxhkd ()
  "Open the sxhkdrc file."
  (interactive)
  (find-file "~/.config/sxhkd/sxhkdrc"))

(defun jsm/sxhkd-scripts ()
  "Open the sxhkd scripts directory."
  (interactive)
  (find-file "~/.config/sxhkd/scripts/"))

(defun jsm/bspwm ()
  "Open the bspwmrc file."
  (interactive)
  (find-file "~/.config/bspwm/bspwmrc"))

(defun jsm/polybar ()
  "Open the polybar config file."
  (interactive)
  (find-file "~/.config/polybar/config"))

(defun jsm/init ()
  "Open the Emacs init file."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun jsm/is-macos ()
  "Return t if current system is macOS."
  (interactive)
  (string-equal system-type "darwin"))

(when (jsm/is-macos)
  ;;(setq ns-option-modifier 'super)
  ;;(setq ns-command-modifier 'meta)
  (global-set-key (kbd "<home>") 'move-beginning-of-line)
  (global-set-key (kbd "<end>") 'move-end-of-line))

(defun jsm/is-signiant ()
  (interactive)
  (equal (system-name) "C02F73JAMD6R"))

(defun jsm/sigapp-config ()
  (interactive)
  (find-file "~/Library/Preferences/com.signiant.SigniantClient.json"))

;; ## crux
;;    https://github.com/bbatsov/crux
;; -----------------------------------------------------------------------------
(use-package crux
  :bind
  ("C-c o" . crux-open-with)
  ("S-<return>" . crux-smart-open-line)
  ("S-s-<return>" . crux-smart-open-line-above)
  ("s-d" . crux-duplicate-current-line-or-region)
  ("s-D" . crux-duplicate-and-comment-current-line-or-region-region))

;;    https://github.com/magnars/expand-region.el
;; -----------------------------------------------------------------------------
(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

;; -----------------------------------------------------------------------------
;; ## undo-tree
;;    https://gitlab.com/tsc25/undo-tree (repo)
;;    https://www.dr-qubit.org/undo-tree.html (website)
;; -----------------------------------------------------------------------------
(use-package undo-tree
  :config
  (global-undo-tree-mode +1)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  :diminish)

;; -----------------------------------------------------------------------------
;; ## which-key
;;    https://github.com/justbur/emacs-which-key
;; -----------------------------------------------------------------------------
(use-package which-key
  :init
  ;; Allow C-h to trigger which-key before it is done automatically
  (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly
  ;; after it is triggered.
  (setq which-key-idle-delay 10000)
  (setq which-key-idle-secondary-delay 0.05)
  :config
  (which-key-mode +1)
  :diminish)

;; -----------------------------------------------------------------------------
;; ## Multiple Cursors
;;    https://github.com/magnars/multiple-cursors.el
;; -----------------------------------------------------------------------------
(use-package hydra)
(use-package multiple-cursors :after hydra
  :config
  (defhydra hydra-mc (:color red :hint nil)
    "
^Like^            ^Skip/Delete^      ^Edit^
----------------------------------------------------
_n_: next         _u_: unmark bot    _e_: edit here
_N_: prev         _U_: unmark top    _<_: edit start
_w_: next word    _s_: skip next     _>_: edit end
_W_: prev word    _S_: skip prev     _q_: cancel
"
    ("n" mc/mark-next-like-this)
    ("N" mc/mark-previous-like-this)
    ("w" mc/mark-next-like-this-word)
    ("W" mc/mark-previous-like-this-word)
    ("s" mc/skip-to-next-like-this)
    ("S" mc/skip-to-previous-like-this)
    ("u" mc/unmark-next-like-this)
    ("U" mc/unmark-previous-like-this)
    ("e" mc/edit-lines :color blue)
    ("<" mc/edit-beginnings-of-lines :color blue)
    (">" mc/edit-ends-of-lines :color blue)
    ("q" nil))
  (global-set-key (kbd "C-c m") 'hydra-mc/body))
;; -----------------------------------------------------------------------------
;; / Editor Functionality
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Minibuffer & Narrowing
;; -----------------------------------------------------------------------------
;; ## Vertico
;;    https://github.com/minad/vertico
;; -----------------------------------------------------------------------------
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle nil)
  )

;; This configuration block is from Vertico and should be moved to a better place.
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; -----------------------------------------------------------------------------
;; ## Orderless
;;    https://github.com/oantolin/orderless
;; -----------------------------------------------------------------------------
;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; -----------------------------------------------------------------------------
;; ## Consult;;    https://github.com/minad/consult
;; -----------------------------------------------------------------------------
;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind ;; C-c bindings (mode-specific-map)
  (("C-c M-x" . consult-mode-command)
   ("C-c h" . consult-history)
   ("C-c k" . consult-kmacro)
   ;;("C-c m" . consult-man)
   ("C-c i" . consult-info)
   ([remap Info-search] . consult-info)
   ;; C-x bindings (ctl-x-map)
   ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
   ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
   ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
   ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
   ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
   ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
   ;; Custom M-# bindings for fast register access
   ("M-#" . consult-register-load)
   ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
   ("C-M-#" . consult-register)
   ;; Other custom bindings
   ("M-y" . consult-yank-pop)                ;; orig. yank-pop
   ;; M-g bindings (goto-map)
   ("M-g e" . consult-compile-error)
   ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
   ("M-g g" . consult-goto-line)             ;; orig. goto-line
   ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
   ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)
   ;; M-s bindings (search-map)
   ("M-s d" . consult-find)
   ("M-s D" . consult-locate)
   ("M-s g" . consult-grep)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)
   ;; Isearch integration
   ("M-s e" . consult-isearch-history)
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
   ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
   ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
   ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
   ;; Minibuffer history
   :map minibuffer-local-map
   ("M-s" . consult-history)                 ;; orig. next-matching-history-element
   ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
    
  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"
  
  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 3. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  ;; 4. projectile.el (projectile-project-root)
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 5. No project support
  ;; (setq consult-project-function nil)
  )

;; -----------------------------------------------------------------------------
;; ## Marginalia
;;    https://github.com/minad/marginalia
;; -----------------------------------------------------------------------------
(use-package marginalia
  ;; Either bind `marginalia-cycle' globally or only in the minibuffer
  :bind
  (("M-A" . marginalia-cycle)
   :map minibuffer-local-map
   ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

;; (use-package embark
;;   :bind
;;   (("C-." . embark-act)         ;; pick some comfortable binding
;;    ("M-." . embark-dwim)        ;; good alternative: M-.
;;    ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

;;   :init
;;   ;; Optionally replace the key help with a completing-read interface
;;   (setq prefix-help-command #'embark-prefix-help-command)

;;   ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
;;   ;; strategy, if you want to see the documentation from multiple providers.
;;   (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
;;   ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

;;   :config

;;   ;; Hide the mode line of the Embark live/completions buffers
;;   (add-to-list 'display-buffer-alist
;;                '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
;;                  nil
;;                  (window-parameters (mode-line-format . none)))))

;; ;; Consult users will also want the embark-consult package.
;; (use-package embark-consult
;;   :ensure t ; only need to install it, embark loads it after consult if found
;;   :hook
;;   (embark-collect-mode . consult-preview-at-point-mode))

;; -----------------------------------------------------------------------------
;; ## Projectile
;; -----------------------------------------------------------------------------
(use-package projectile
  :config
  (projectile-mode)
  ;;(setq projectile-com pletion-system 'default)
  ;;(setq projectle-indexing-method 'hybrid)
  (setq projectile-track-known-projects-automatically nil)
  (setq projectile-mode-line-prefix " P#")
  :bind
  (:map projectile-command-map
		("B" . projectile-ibuffer)
		("b" . consult-project-buffer))
  :bind-keymap ("C-c p" . projectile-command-map))

;; -----------------------------------------------------------------------------
;; ## Persp
;;    https://github.com/Bad-ptr/persp-mode.el
;; -----------------------------------------------------------------------------
(use-package persp-mode
  :init
  (setq-default persp-keymap-prefix (kbd "C-c C-SPC"))
  (global-set-key (kbd "C-c w B") #'(lambda (arg)
                                      (interactive "P")
                                      (with-persp-buffer-list () (ibuffer arg))))

  (setq persp-add-buffer-on-find-file t)
  :config
  (persp-mode +1)
  :bind
  ;;("C-c C-SPC" . persp-frame-switch)
  ("M-s-<right>" . persp-next)
  ("M-s-<left>" . persp-prev)
  )

;; https://github.com/Bad-ptr/persp-mode.el#keep-most-recently-used-perspectives-on-top
;; These hooks keep the most recently used persps on top
(with-eval-after-load "persp-mode"
  (add-hook 'persp-before-switch-functions
            #'(lambda (new-persp-name w-or-f)
                (let ((cur-persp-name (safe-persp-name (get-current-persp))))
                  (when (member cur-persp-name persp-names-cache)
                    (setq persp-names-cache
                          (cons cur-persp-name
                                (delete cur-persp-name persp-names-cache)))))))

  (add-hook 'persp-renamed-functions
            #'(lambda (persp old-name new-name)
                (setq persp-names-cache
                      (cons new-name (delete old-name persp-names-cache)))))

  (add-hook 'persp-before-kill-functions
            #'(lambda (persp)
                (setq persp-names-cache
                      (delete (safe-persp-name persp) persp-names-cache))))

  (add-hook 'persp-created-functions
            #'(lambda (persp phash)
                (when (and (eq phash *persp-hash*)
                           (not (member (safe-persp-name persp)
                                        persp-names-cache)))
                  (setq persp-names-cache
                        (cons (safe-persp-name persp) persp-names-cache))))))


;; -----------------------------------------------------------------------------
;; ## Eyebrowse
;;    https://depp.brause.cc/eyebrowse/
;; ------------------------------- ----------------------------------------------
;; (use-package eyebrowse
;;   :init
;;   (setq-default eyebrowse-keymap-prefix (kbd "C-c w"))
;;   :bind
;;   ("M-s-<right>" . eyebrowse-next-window-config)
;;   :config
;;   (eyebrowse-mode +1)
;;   )

;; -----------------------------------------------------------------------------
;; / Project Management
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Search
;; -----------------------------------------------------------------------------
;; ## Ripgrep
;;    https://github.com/dajva/rg.el
;;    https://www.reddit.com/r/emacs/comments/u4c5rc/ripgrep_is_fantastic_emacs_is_fantastic_boom_you/
;; -----------------------------------------------------------------------------
(use-package rg
  :bind
  ("C-c R" . rg-menu)
  ("C-c r" . rg))

;; -----------------------------------------------------------------------------
;; ## TODO wgrep + visual-regexp-steroids
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Org Mode
;; -----------------------------------------------------------------------------
;; ## Org Superstar
;; -----------------------------------------------------------------------------
(use-package org-superstar
  :init
  (setq org-superstar-headline-bullets-list '("▷" "▢" "☆" "◇" "◦"))
  (setq org-superstar-item-bullet-alist '((42 . 8226) (43 . 10140) (45 . 187))))

;; -----------------------------------------------------------------------------
;; ## Org
;; -----------------------------------------------------------------------------


(defun jsm/org-set-done-with-timestamp ()
  "With this function, org-log-done can be let off and you can ask to have a timestamp set explicitly."
  (interactive)
  (setq org-log-done 'time)
  (org-todo 'done)
  (setq org-log-done nil))

(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode +1)
            (auto-fill-mode +1)
            (org-superstar-mode +1)))

(use-package org
  :init
  (setq org-startup-indented +1)
  (progn
    (if (jsm/is-macos)
        (add-to-list 'org-file-apps '("pdf" . "open %s"))
      (add-to-list 'org-file-apps '("pdf" . "evince %s"))
      ))
  (setq org-export-with-section-numbers nil) ; disable numbered headers in org export
  (setq org-support-shift-select t)
  (setq org-special-ctrl-a/e t) ; Don't jump to beginning of stars or to end of tags
  (setq org-return-follows-link t) ; Follow link with RET
  (defvar org-dir (concat (getenv "HOME") "/Org") "Org directory.")
  (setq org-archive-location (concat org-dir "/__archived__/done.org::* From %s"))
  ;; Todo, On-hold, Done, Cancelled
  (setq org-todo-keywords '((sequence "⭘(t)" "━(h)" "|" "✔(d)" "✖(c)")))
  
  :bind
  ("C-c a" . org-agenda)
  ("C-c s" . org-store-link)
  ("C-c t" . org-time-stamp-inactive)
  ("C-c o" . org-switchb)
  ("C-c d" . jsm/org-set-done-with-timestamp)
  
  :after org-superstar)

;; -----------------------------------------------------------------------------
;; / Org Mode
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # General Programming Features
;; -----------------------------------------------------------------------------
;; ## Company
;;    https://company-mode.github.io/
;; -----------------------------------------------------------------------------
(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :bind
  ("C-S-SPC" . company-complete)
  ("M-/" . company-dabbrev)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1)
  (company-backends
   '(company-files
	 (company-capf company-yasnippet))) ; If autocomplete acts weird it is probably this
  (company-files-exclusions '(".git/" ".DS_Store" "env"))
  :diminish)

(use-package yasnippet
  :demand
  :functions (yas-reload-all)
  :config
  (yas-reload-all)
  :hook
  (prog-mode . yas-minor-mode)
  :diminish " Y")

(use-package yasnippet-snippets)
(use-package go-snippets)

;; -----------------------------------------------------------------------------
;; ## Syntax Checking
;;    Flycheck https://www.flycheck.org/en/latest/
;; -----------------------------------------------------------------------------
(use-package flycheck
  :functions (global-flycheck-mode)
  :init (global-flycheck-mode)
  :diminish " fc")

;; -----------------------------------------------------------------------------
;; ## IEdit
;;    https://github.com/victorhge/iedit
;; -----------------------------------------------------------------------------
(use-package iedit)

;; -----------------------------------------------------------------------------
;; ## LSP
;;    https://emacs-lsp.github.io/lsp-mode/page/installation/
;; -----------------------------------------------------------------------------
;;(use-package consult-lsp)
;;(use-package lsp-ui)
;;(use-package lsp-treemacs
;;  :functions (lsp-treemacs-errors-list)
;;  :bind
;;  ("C-x T e" . lsp-treemacs-errors-list))
;;
;;(use-package lsp-mode
;;  :commands lsp
;;  :bind
;;  ("C-h t" . lsp-ui-doc-glance)
;;  ("C-h ." . lsp-ui-doc-focus-frame)
;;  ("C-:" . lsp-iedit-highlights)
;;  :custom
;;  (lsp-keymap-prefix "s-l")
;;  (lsp-diagnostics-flycheck-default-level 'info)
;;  (lsp-diagnostic-clean-after-change t)
;;  (lsp-completion-provider :none) ; this is required for yasnippet to work with lsp
;;  :hook
;;  (go-mode . lsp)
;;  (c-mode . lsp)
;;  ;;(sh-mode . lsp)
;;  ;;(terraform-mode . lsp)
;;  (lsp-mode . lsp-enable-which-key-integration)
;;  (dired-mode . lsp-dired-mode))
;;
;; -----------------------------------------------------------------------------
;; # Git
;; -----------------------------------------------------------------------------
;; ## Magit
;;    https://magit.vc/
;; -----------------------------------------------------------------------------
(use-package magit
  :commands
  (magit-status)
  :defines
  (magit-status-mode-map)
  :bind
  (("C-c g" . magit-status)
   ("C-c G" . magit-dispatch)
   ("C-c f" . magit-file-dispatch)
   :map magit-status-mode-map
   ("C-o" . magit-diff-visit-file-other-window))
  :custom
  (magit-define-global-key-bindings nil)
  ;; Show diffs at character-level rather than line in magit
  (magit-diff-refine-hunk (quote all)))

;; -----------------------------------------------------------------------------
;; ## git-gutter+
;;    https://github.com/nonsequitur/git-gutter-plus
;; -----------------------------------------------------------------------------
(use-package git-gutter+
;;  :demand
  :config
  (git-gutter+-mode 1)
  (defhydra hydra-git-gutter (:body-pre (git-gutter+-mode 1)
                                        :hint nil)
    "
Git gutter:
  _n_ext hunk        _s_tage hunk     _q_uit
  _p_revious hunk    _r_evert hunk    _m_agit status 
  ^ ^                pop_u_p hunk
  _f_irst hunk
  _l_ast hunk
"
    ("n" git-gutter+-next-hunk)
    ("p" git-gutter+-previous-hunk)
    ("f" (progn (goto-char (point-min))
                (git-gutter+-next-hunk 1)))
    ("l" (progn (goto-char (point-min))
                (git-gutter+-previous-hunk 1)))
    ("s" git-gutter+-stage-hunks)
    ("r" git-gutter+-revert-hunks)
    ("u" git-gutter+-popup-hunk)
    ("q" nil :color blue)
	("m" magit-status :color blue)))
(global-set-key (kbd "C-c +") 'hydra-git-gutter/body)
;; -----------------------------------------------------------------------------
;; ## git-timemachine
;;    https://github.com/purcell/git-timemachine
;; -----------------------------------------------------------------------------
(use-package git-timemachine)

;; -----------------------------------------------------------------------------
;; # Programming Modes
;; -----------------------------------------------------------------------------
;; ## Elisp
;; -----------------------------------------------------------------------------
;; ### eldoc
(use-package eldoc
  :diminish)

;; -----------------------------------------------------------------------------
;; ### macrostep
;;     https://github.com/joddie/macrostep
(use-package macrostep
  :config
  (setq use-package-expand-minimally t)
  :bind
  (:map emacs-lisp-mode-map ("C-c M" . macrostep-expand)))

;; -----------------------------------------------------------------------------
;; ### Eros (Evaluation Result OverlayS for Emacs Lisp.)
;;     https://github.com/xiongtx/eros
;; -----------------------------------------------------------------------------
;;(use-package eros)

;; -----------------------------------------------------------------------------
;; ### Terraform Mode
;;     https://github.com/emacsorphanage/terraform-mode
;;     https://emacs-lsp.github.io/lsp-mode/page/lsp-terraform/
;; -----------------------------------------------------------------------------
(use-package terraform-mode
  :disabled t
  :init
  (add-hook 'terraform-mode-hook #'outline-minor-mode))

;; -----------------------------------------------------------------------------
;; ## Markdown
;;    https://jblevins.org/projects/markdown-mode/
;; -----------------------------------------------------------------------------
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; ### Markdown Live Preview

;; -----------------------------------------------------------------------------
;; ## Yaml
;;    https://github.com/yoshiki/yaml-mode (needs maintainer)
;; -----------------------------------------------------------------------------
(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))


;; TODO Setup the debugger
;;(use-package dap-mode)
;;  (use-package dap-LANGUAGE) to load the dap adapter for your language

;; -----------------------------------------------------------------------------
;; ## go
;;    https://github.com/dominikh/go-mode.el
;; -----------------------------------------------------------------------------
(use-package go-mode
  :bind
  ("C-c C-t" . jsm-go-run-test))

(defun jsm-go-run-test ()
  (interactive)
  ;; C-u, this causes to jump all the way to the containing function if called from within a macro
  (setq current-prefix-arg '(4))
  (call-interactively 'go-goto-function-name)
  (let ((test (thing-at-point 'symbol)))
	(compile (format "go test -count=1 -v %s -run %s" default-directory test))))

(defun jsm-go-run-test-all ()
  (interactive)
  (compile (format "go test -v %s" default-directory)))

(defun jsm-go-get-restless (hash)
  (interactive "sCommit Hash: ")
  (let ((url (format "go get bitbucket.org/signiant/restless@%s" hash)))
	(message url)
	(shell-command url)))

;; -----------------------------------------------------------------------------
;; ## kubernetes
;;    https://github.com/kubernetes-el/kubernetes-el
;;    https://github.com/TxGVNN/emacs-k8s-mode
;; -----------------------------------------------------------------------------
;;(use-package kubernetes :bind ("s-k" . kubernetes-overview))
;;(use-package k8s-mode :hook (k8s-mode . yas-minor-mode))
;; -----------------------------------------------------------------------------
;; # Misc.
;; -----------------------------------------------------------------------------
;; ## Compile mode
;;    Support colour escape codes, i.e. coloured output
(use-package compile
  :hook
  (compilation-filter . ansi-color-compilation-filter))

;; See here https://stackoverflow.com/questions/4157147/compile-buffer-to-show-in-a-vertical-buffer
;; (defadvice compile (around split-horizontally activate)
;;   (let ((split-width-threshold nil)
;;         (split-height-threshold 0))
;;     ad-do-it))
;; -----------------------------------------------------------------------------
;; / Misc.
;; -----------------------------------------------------------------------------

;; -----------------------------------------------------------------------------
;; # Custom
;; -----------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ignored-local-variable-values
   '((helm-ctest-dir . "~/Dev/Code/Bolt/cmake-build-emacs")
	 (helm-make-arguments . "-j15")
	 (helm-make-build-dir . "cmake-build-emacs")
	 (cmake-ide-cmake-opts . "-DCMAKE_BUILD_TYPE=DEBUG -DFETCHCONTENT_QUIET=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=YES")
	 (cmake-ide-build-dir . "~/Dev/Code/Bolt/cmake-build-emacs")
	 (cmake-ide-project-dir . "~/Dev/Code/Bolt")
	 (projectile-indexing-method . native)
	 (projectile-enable-caching . t)))
 '(kubernetes-overview-custom-views-alist
   '((All context configmaps deployments statefulsets ingress pods secrets services nodes persistentvolumeclaims)))
 '(org-agenda-files
   '("~/Org/Journal.org" "~/Org/Personal/Finances/Finances.org" "~/Org/Signiant/MA-391.org" "~/Org/Signiant/GTD.org"))
 '(org-enforce-todo-checkbox-dependencies t)
 '(org-enforce-todo-dependencies t)
 '(persp-auto-resume-time -1.0)
 '(persp-lighter
   '(:eval
	 (format
	  (propertize " p#%s" 'face
				  (let
					  ((persp
						(get-current-persp)))
					(if persp
						(if
							(persp-contain-buffer-p
							 (current-buffer)
							 persp)
							'persp-face-lighter-default 'persp-face-lighter-buffer-not-in-persp)
					  'persp-face-lighter-nil-persp)))
	  (safe-persp-name
	   (get-current-persp)))))
 '(persp-mode t nil (persp-mode))
 '(safe-local-variable-values '((org-superstar-special-todo-items . hide)))
 '(terraform-format-on-save t)
 '(vc-display-status nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(iedit-occurrence ((t (:background "DarkOrange3" :foreground "gray100" :weight bold))))
 '(markdown-code-face ((t (:inherit JetBrains\ Mono))))
 '(persp-face-lighter-buffer-not-in-persp ((t (:foreground "orange1"))))
 '(persp-face-lighter-default ((t nil)))
 '(terraform-resource-name-face ((t (:foreground "MediumPurple1")))))

;;; init.el ends here
