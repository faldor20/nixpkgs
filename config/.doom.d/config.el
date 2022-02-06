;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "/home/eli/Notes/personal/pages" )
(setq org-roam-directory org-directory)

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
(setq ispell-dictionary "en")

;;=======CODE=======
;;
;;----FSHARP-----
(setq lsp-fsharp-server-install-dir "~/Downloads/fsautocomplete.netcore")
;;===WAYLAND===

;;=====deft setup for org roam===
 (setq deft-recursive t)
 ;; (deft-use-filter-string-for-filename t)
  ;;(deft-default-extension "org")
  (setq deft-directory org-directory)
;;====undo tree====
;; allows visualisation fo undo hsitory
(setq global-undo-tree-mode t)

;;======org=====
;; nice heading sizes
(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.25)
  '(outline-2 :weight bold :height 1.15)
  '(outline-3 :weight bold :height 1.12)
  '(outline-4 :weight semi-bold :height 1.09)
  '(outline-5 :weight semi-bold :height 1.06)
  '(outline-6 :weight semi-bold :height 1.03)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold))
;; title size
;;(after! org
;;  (custom-set-faces!
;;    '(org-level-1 :inherit outline-1 :weight extra-bold :height 1.25)
;;    '(org-level-2 :inherit outline-2 :weight bold :height 1.15)
;;    '(org-level-3 :inherit outline-3 :weight bold :height 1.12)
;;    '(org-level-4 :inherit outline-4 :weight bold :height 1.09)
;;    '(org-level-5 :inherit outline-5 :weight semi-bold :height 1.06)
;;    '(org-level-6 :inherit outline-6 :weight semi-bold :height 1.03)
;;    '(org-level-7 :inherit outline-7 :weight semi-bold)
;;    '(org-level-8 :inherit outline-8 :weight semi-bold)
;;    '(org-document-title :height 1.3)))



;;Autosave org buffers::
(add-hook 'auto-save-hook 'org-save-all-org-buffers)
;;===============org roam ========================
;;manually set subdirectty for notes:
(defun +org-notes-location () "./org/roam")
;;if a selectable subdiri s desired change "org0- notes-subdir" in the function below to "+org-notes-subdir"
;;(setq org-roam-graph-executable "neato")
(setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "${slug}.org"
		     "#+title: ${title}\n#+TIME-STAMP: <>\n\n" )
           :unnarrowed t)))

(defun +org-notes-subdir ()
  "Select notes subdirectory."
  (interactive)
  (let ((dirs (cons "."
                    (seq-map
                     (lambda (p)
                       (string-remove-prefix org-roam-directory p))
                     (+file-subdirs org-roam-directory nil t)))))
    (completing-read "Subdir: " dirs nil t)))

(defun +file-subdirs (directory &optional filep rec)
  "Return subdirs or files of DIRECTORY according to FILEP.

If REC is non-nil then do recursive search."
  (let ((res
         (seq-remove
          (lambda (file)
            (or (string-match "\\`\\."
                              (file-name-nondirectory file))
                (string-match "\\`#.*#\\'"
                              (file-name-nondirectory file))
                (string-match "~\\'"
                              (file-name-nondirectory file))
                (if filep
                    (file-directory-p file)
                  (not (file-directory-p file)))))
          (directory-files directory t))))
    (if rec
        (+seq-flatten
         (seq-map (lambda (p) (cons p (+file-subdirs p)))
                  res))
      res)))

(defun +seq-flatten (list-of-lists)
  "Flatten LIST-OF-LISTS."
  (apply #'append list-of-lists))
;; org-roam export
(defun benmezger/org-roam-export-all ()
   "Re-exports all Org-roam files to Hugo markdown."
   (interactive)
   (dolist (f (org-roam--list-all-files))
     (with-current-buffer (find-file f)
       (when (s-contains? "SETUPFILE" (buffer-string))
	 (org-hugo-export-wim-to-md)))))
 (defun benmezger/org-roam--backlinks-list (file)
   (when (org-roam--org-roam-file-p file)
     (mapcar #'car (org-roam-db-query [:select :distinct [from]
				       :from links
				       :where (= to $s1)
				       :and from :not :like $s2] file "%private%"))))
 (defun benmezger/org-export-preprocessor (_backend)
   (when-let ((links (benmezger/org-roam--backlinks-list (buffer-file-name))))
     (insert "\n** Backlinks\n")
     (dolist (link links)
       (insert (format "- [[file:%s][%s]]\n"
		       (file-relative-name link org-roam-directory)
		       (org-roam--get-title-or-slug link))))))

;(add-hook 'org-export-before-processing-hook #benmezger/org-export-preprocessor)

;;================Org-Roam==============================
(map! :after org-roam-mode
      :map org-roam-mode-map
      :i "C-S-i" 'org-roam-insert-immediate)
;;---org roam UI----
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


;;======editor=======
;;------fonts--------
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
(setq doom-font (font-spec :family "Jetbrains Mono" :size 15)
      doom-big-font (font-spec :family "JetBrains Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 15)
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light))
;;====Markdown=====
(setq markdown-header-scaling t)
;; nice heading sizes
(custom-set-faces!
  '(markdown-header-face-1 :weight extra-bold :height 1.25)
  '(markdown-header-face-2 :weight bold :height 1.15)
  '(markdown-header-face-3 :weight bold :height 1.12)
  '(markdown-header-face-4 :weight semi-bold :height 1.09)
  '(markdown-header-face-5 :weight semi-bold :height 1.06)
  '(markdown-header-face-6 :weight semi-bold :height 1.03)
  '(markdown-header-face-8 :weight semi-bold)
  '(markdown-header-face-9 :weight semi-bold))

;;===== editor=====
;; ctrl+backspace behaviour like vscode
(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word."
  (interactive)
  (let* ((cp (point))
         (backword)
         (end)
         (space-pos)
         (backword-char (if (bobp)
                            ""           ;; cursor in begin of buffer
                          (buffer-substring cp (- cp 1)))))
    (if (equal (length backword-char) (string-width backword-char))
        (progn
          (save-excursion
            (setq backword (buffer-substring (point) (progn (forward-word -1) (point)))))
          (setq ab/debug backword)
          (save-excursion
            (when (and backword          ;; when backword contains space
                       (s-contains? " " backword))
              (setq space-pos (ignore-errors (search-backward " ")))))
          (save-excursion
            (let* ((pos (ignore-errors (search-backward-regexp "\n")))
                   (substr (when pos (buffer-substring pos cp))))
              (when (or (and substr (s-blank? (s-trim substr)))
                        (s-contains? "\n" backword))
                (setq end pos))))
          (if end
              (kill-region cp end)
            (if space-pos
                (kill-region cp space-pos)
              (backward-kill-word 1))))
      (kill-region cp (- cp 1)))         ;; word is non-english word
    ))

(global-set-key  [C-backspace]
                 'aborn/backward-kill-word)

;;=== small utility stuff===
;;save undo history
(setq-default indent-tabs-mode t)
(setq indent-tabs-mdiffde t)
(after! org
  (setq indent-tabs-mode t))
;;==========autocomplete========
;;instant autocompetions
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq  lsp-rust-analyzer-server-display-inlay-hints t)
;;enales the function signature popup to occur in a box near the cursur instead of at the bottom of the window
(setq lsp-signature-function 'lsp-signature-posframe)
(setq lsp-semantic-tokens-enable t)

;;=====Tree sitter======
(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
