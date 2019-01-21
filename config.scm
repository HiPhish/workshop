#!/usr/bin/guile
!#
;;; Copyright 2019 Alejandro "HiPhish" Sanchez
;;;
;;; This file is part of The Workshop.
;;;
;;; The Workshop is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; The Workshop is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with The Workshop.  If not, see <https://www.gnu.org/licenses/>.

(define-module (config)
  #:use-module ((srfi srfi-19)
                #:select (current-date date-year))
  #:export (base-data))

;;; ===========================================================================
;;;    GLOBAL SETTINGS AND CONFIGURATION FOR THE SITE GENERATION PROCESS
;;; ===========================================================================
;;;
;;; The generation will be run from based on this data.

(define site-name "HiPhish's Workshop")
(define title site-name)

(define menu-bar
  '((left  . (((title . "Grid Framework"  )
               (url   . "/grid-framework/")
               (items . (((title . "Overview")
                          (url   . "/grid-framework/"))
                         ()
                         ((title . "Features")
                          (url   . "/grid-framework/features/"))
                         ((title . "Examples")
                          (url   . "/grid-framework/examples/"))
                         ((title . "Gallery")
                          (url   . "/grid-framework/gallery/"))
                         ((title . "Showcase")
                          (url   . "/grid-framework/showcase/"))
                         ((title . "FAQ")
                          (url   . "/grid-framework/faq/"))
                         ((title . "News")
                          (url   . "/grid-framework/news/"))
                         ()
                         ((title . "Support")
                          (url   . "http://forum.unity3d.com/threads/grid-framework-scripting-and-editor-plugins.144886/"))
                         ()
                         ((title . ("Buy Now " (span (@ (class "badge"))"35$")))
                          (url   . "https://www.assetstore.unity3d.com/#/content/62498")))))
              ((title . "Open Source"      ) 
               (url   . "/open-source/"    )
               (items . (((title . "NTFS-Clone")
                          (url   . "https://gitlab.com/HiPhish/ntfs-clone"))
                         ((title . "roll")
                          (url   . "https://gitlab.com/HiPhish/roll"))
                         ((title . "Newton's Method in C")
                          (url   . "https://github.com/HiPhish/Newton-method"))
                         ((title . "Xeen Tools")
                          (url   . "https://github.com/HiPhish/XeenTools"))
                         ((title . "Wolf3D Extract")
                          (url   . "https://github.com/HiPhish/Wolf3DExtract"))
                         ((title . "Game Source Documentation")
                          (url   . "https://github.com/HiPhish/Game-Source-Documentation")))))
              ((title . "Vim/Nvim plugins" )
               (url   . "/vim/"            )
               (items . (((title . "Info.vim")
                          (url   . "https://gitlab.com/HiPhish/info.vim"))
                         ((title . "REPL.nvim")
                          (url   . "https://gitlab.com/HiPhish/repl.nvim"))
                         ((title . "Quicklisp.nvim")
                          (url   . "https://gitlab.com/HiPhish/quicklisp.nvim"))
                         ((title . "jinja.vim")
                          (url   . "https://gitlab.com/HiPhish/jinja.vim"))
                         ((title . "Guix channel")
                          (url   . "https://gitlab.com/HiPhish/neovim-guix-channel/")))))))
    (right . (((title . "Blog"   )
               (url   . "/blog/" ))
              ((title . "About"  )
               (url   . "/about/"))))))

(define footer
  `((logo . ((title . ,title)
             (image . "/img/footer/logo.png")
             (url   . "/")))
    (copyright . ((note . ("© 2015-"
                           ,(simple-format #f "~A" (date-year (current-date)))
                           ", licensed under "
                           (a (@ (href "http://creativecommons.org/licenses/by-sa/4.0/"))
                             "CC BY-SA 4.0")))
                  (title . "Creative Commons Attribution-ShareAlike 4.0 International License")
                  (image . "/img/footer/cc.svg")
                  (url   . "http://creativecommons.org/licenses/by-sa/4.0/")))
    (social . (((title . "GitHub")
                (image . "/img/footer/github.png")
                (url   . "https://github.com/HiPhish"))
               ((title . "GitLab")
                (image . "/img/footer/gitlab.png")
                (url   . "https://gitlab.com/HiPhish"))))))

(define sub-sites
  '((grid-framework . ((title . "Grid Framework")
                       (url   . "/grid-framework/")
                       (items . (((title . "Features")
                                  (url   . "/grid-framework/features/"))
                                 ((title . "Examples")
                                  (url   . "/grid-framework/examples/"))
                                 ((title . "Gallery")
                                  (url   . "/grid-framework/gallery/"))
                                 ((title . "Showcase")
                                  (url   . "/grid-framework/showcase/"))
                                 ((title . "FAQ")
                                  (url   . "/grid-framework/faq/"))
                                 ((title . "News")
                                  (url   . "/grid-framework/news/"))
                                 ((title . "Support")
                                  (url   . "http://forum.unity3d.com/threads/grid-framework-scripting-and-editor-plugins.144886/"))
                                 ((title . ("Buy " (span (@ (class "badge")) "35$")))
                                  (url   . "https://www.assetstore.unity3d.com/#/content/62498/"))))))))

(define blogs
  '(((title       . "HiPhish's Workshop: Blog")
     (top         . "blog")
     (url         . "/blog/")
     (description . "Software projects, various thoughts and rablings")
     (author      . "HiPhish"))
    ((title       . "Grid Framework News")
     (top         . "news")
     (url         . "/grid-framework/news/")
     (description . "News for the Grid Framework plugin for Unity3D")
     (sub-site    . grid-framework)
     (author      . "HiPhish"))))

;; Metadata to be passed to the base page template
(define base-data
  `((site-name . ,site-name)
    (title     . ,title    )
    (url       . ""        )  ; The URL should be overridden by CLI arguments
    (sub-sites . ,sub-sites)
    (menu-bar  . ,menu-bar )
    (footer    . ,footer   )
    (blogs     . ,blogs    )))
