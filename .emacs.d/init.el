;;;; Vanilla Emacs configuration

;;; Packages

;; Set up MELPA.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

(require 'evil)

;;; General

(custom-set-variables
 '(blink-cursor-delay 0.5)
 '(blink-cursor-interval 0.5)
 '(blink-cursor-mode t)
 '(column-number-mode t)
 '(cursor-type 'bar)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

;; Disable bell.
(setq visible-bell 1)

;; Set default directory to home.
(setq default-directory (concat (getenv "HOME") "/"))

;;; Editor

;; Evil mode.
(evil-mode 1)

;; Tabs.
(setq-default indent-tabs-mode t)
(setq tab-width 4)

;;; Appearance

;; Color theme.
(load-theme 'monokai-pro t)

;; Font face.
(custom-set-faces
 '(default ((t (:family "Iosevka SS04 Extended" :foundry "BE5N" :slant normal :weight normal :height 120 :width normal)))))
