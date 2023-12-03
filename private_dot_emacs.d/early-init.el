;;; early-init.el --- Early Init  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Setup GUI
(setq-default
 default-frame-alist
 '((font . "JetBrainsMono NF-12")
   (bottom-divider-width . 1)           ; Thin horizontal window divider
   (horizontal-scroll-bars . nil)       ; No horizontal scroll-bars
   (left-fringe . 8)                    ; Thin left fringe
   (menu-bar-lines . 0)                 ; No menu bar
   (right-divider-width . 1)            ; Thin vertical window divider
   (right-fringe . 8)                   ; Thin right fringe
   (tool-bar-lines . 0)                 ; No tool bar
   ;;(undecorated . t)                  ; Remove extraneous X decorations
   (vertical-scroll-bars . nil))        ; No vertical scroll-bars
 )

;; Disable package.el from loading
;;   From https://github.com/radian-software/straight.el#getting-started
(setq package-enable-at-startup nil)
;;; early-init.el ends here


