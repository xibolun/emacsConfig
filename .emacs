;;配置Emacs源
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;  backup file
(setq backup-directory-alist (quote (("." . "~/.emacs.d/backupfiles"))))

;; [Facultative] Only if you have installed async.
(add-to-list 'load-path "~/.emacs.d/plugins/async")

;; helm配置信息
(add-to-list 'load-path "~/.emacs.d/plugins/helm")
(require 'helm)
(require 'helm-config)
					;(require 'helm-dash)

(helm-mode 1)
(helm-autoresize-mode 1)
					;(setq helm-ff-auto-update-initial-value nil)    ; 禁止自动补全

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-s") 'helm-occur)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)

(setq helm-split-window-in-side-p           t
      helm-move-to-line-cycle-in-source     t
      helm-ff-search-library-in-sexp        t
      helm-M-x-fuzzy-match                  t   ; 模糊搜索
      helm-buffers-fuzzy-matching           t
      helm-locate-fuzzy-match               t
      helm-recentf-fuzzy-match              t
      helm-scroll-amount                    8
      helm-ff-file-name-history-use-recentf t)

(provide 'init-helm)

;;添加js2-mode配置
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;配置Emmet
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-to-list 'auto-mode-alist '("\\.hbs$" . emmet-mode))

;; color Theme
(add-to-list 'load-path "~/.emacs.d/plugins/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-gnome2)

;;; 添加emberJs 模式
					;(add-to-list 'load-path "~/.emacs.d/plugins/ember-mode/")
					;(require 'ember-mode)

;; 以 y/n代表 yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; 显示括号匹配
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;去掉Emacs和gnus启动时的引导界面
(setq inhibit-startup-message t)
(setq gnus-inhibit-startup-message t)

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
			     "python -mjson.tool" (current-buffer) t)))

;; 设置emacs的markdown模式
(add-to-list 'load-path "~/.emacs.d/plugins")
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '(".markdown" . markdown-mode) auto-mode-alist))

;; use only one desktop
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")

;; resolve the problem: "desktop file appears to be in use by PID ***"
(setq-default desktop-load-locked-desktop t)

;; remove desktop after it's been read
(add-hook 'desktop-after-read-hook
          '(lambda ()
             ;; desktop-remove clears desktop-dirname
             (setq desktop-dirname-tmp desktop-dirname)
             (desktop-remove)
             (setq desktop-dirname desktop-dirname-tmp)))

(defun saved-session ()
  (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))

;; use session-restore to restore the desktop manually
(defun session-restore ()
  "Restore a saved emacs session."
  (interactive)
  (if (saved-session)
      (desktop-read)
    (message "No desktop found.")))

;; use session-save to save the desktop manually
(defun session-save ()
  "Save an emacs session."
  (interactive)
  (if (saved-session)
      (if (y-or-n-p "Overwrite existing desktop? ")
          (desktop-save-in-desktop-dir)
        (message "Session not saved."))
    (desktop-save-in-desktop-dir)))

;; ask user whether to restore desktop at start-up
(add-hook 'after-init-hook
          '(lambda ()
             (if (saved-session)
                 ;; (if (y-or-n-p "Restore desktop? ")
		 (session-restore))))

(add-hook 'kill-emacs-hook
          '(lambda ()
             (session-save)))

;; display line num
(global-linum-mode t)
(setq column-number-mode t)
(put 'upcase-region 'disabled nil)

;; setting C-k kill whole-line like vim "dd"
(global-set-key (kbd "M-k") 'kill-whole-line)

;;中文与外文字体设置
;; Setting English Font
(defun set-font (english chinese english-size chinese-size)
  (set-face-attribute 'default nil :font
                      (format   "%s:pixelsize=%d"  english english-size))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family chinese :size chinese-size))))
(set-font   "WenQuanYi Zen Hei Mono" "WenQuanYi Zen Hei Mono" 14 14)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; org-mode setting;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;配置org-mode当中的table-mode
(add-to-list 'load-path "~/.emacs.d/plugins/")
(require'table)
(autoload 'table-insert "table" "WYGIWYS table editor")

;;配置org-model当中的table + 为 |

;;配置Yasnippet
(require 'yasnippet)
;设置snippet目录
(setq yas-snippet-dirs '(
			 "~/.emacs.d/plugins/snippets" ;personal snippets
			 "~/.emacs.d/elpa/yasnippet-0.8.0/snippets" ;default
			 ))
(yas-global-mode 1)

;;设置org-mode导出为markdown
(eval-after-load "org"
  '(require 'ox-md nil t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(org-agenda-files
   (quote
    ("~/PengGy/Lord/christSchool/学习神的话语.org" "~/YunJi/puppetManager/tmplDesign.org")))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)

;;setting src code hiliting
(setq org-src-fontify-natively t)
(defface org-block-begin-line
  '((t (:underline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF")))
  "Face used for the line delimiting the begin of source blocks.")

(defface org-block-background
  '((t (:background "#000000")))
  "Face used for the source block background.")

(defface org-block-end-line
  '((t (:overline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF")))
  "Face used for the line delimiting the end of source blocks.")
