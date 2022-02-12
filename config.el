;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin")))

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;; (setq doom-font (font-spec :family "Liberation Mono" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(custom-theme-set-faces! 'doom-nord
  '(default :background nil))
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! reformatter
  :config
  (reformatter-define tqformat
    :program "tqformat"
    :args '("-")
    :lighter " TQF")
  (reformatter-define clang-format
    :program "clang-format")
  )

(use-package! string-inflection)

(after! elm-mode
  (setq elm-format-on-save t))

(after! dhall-mode
  (setq dhall-use-header-line nil))

;; Stop inserting a magic #coding comment
(after! ruby-mode
  (setq ruby-insert-encoding-magic-comment nil))

(defun zwilias/alternate-window ()
  "Switch back and forth between current and last window in the
current frame."
  (interactive)
  (let (;; switch to first window previously shown in this frame
        (prev-window (get-mru-window nil t t)))
    ;; Check window was not found successfully
    (unless prev-window (user-error "Last window not found."))
    (select-window prev-window)))

(map! :leader
      "w <left>"  'evil-window-left
      "w <down>"  'evil-window-down
      "w <up>"  'evil-window-up
      "w <right>"  'evil-window-right
      "w TAB"  'zwilias/alternate-window
      "C-h C-m" 'discover-my-major
      "c l" 'comment-line)

(use-package! envrc :config (envrc-global-mode))

(unless (display-graphic-p)
  (xterm-mouse-mode t)
  ;; activate mouse-based scrolling
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

(add-to-list 'auto-mode-alist '("\\.tf\\'" . hcl-mode))
