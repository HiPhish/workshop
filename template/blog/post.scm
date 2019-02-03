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

(define-module (template blog post)
  #:use-module ((rnrs lists) #:version (6)
                #:select (find))
  #:use-module ((srfi srfi-19)
                #:select (date->string))
  #:export (post))

(define (post data)
  "Template for an individual blog post. Required metadata:
  
  - blog  Information on the blog
  - post  The current post to display
  
Optional metadata:

  - prev  Previous post
  - next  Next post"

  (define blog     (assq-ref data 'blog    ))
  (define post     (assq-ref data 'post    ))
  (define prev     (assq-ref data 'prev    ))
  (define next     (assq-ref data 'next    ))

  (define status   (assq-ref post 'status  ))
  (define date     (assq-ref post 'date    ))
  (define modified (assq-ref post 'modified))
  (define content  (assq-ref post 'content ))

  (define category
    (find (λ (c)
            (string=? (assq-ref post 'category)
                      (assq-ref c 'title)))
          (assq-ref data 'categories)))

  (define tags
    (map (λ (tag)
           (find (λ (t)
                   (string=? tag
                             (assq-ref t 'title)))
                 (assq-ref data 'tags)))
         (assq-ref post 'tags)))

  ;; Extra CSS for blogs
  (define css '("/css/article.css"))
  ;; Breadcrumbs for blog navigation; clicking a date portion takes us to that
  ;; date period archive. This is flawed because it assumes that the period
  ;; granularity is always the same.
  (define breadcrumbs
    `(((title . ,(assq-ref blog 'top))
       (url   . "../../../.."))
      ((title . ,(date->string date "~Y"))
       (url   . "../../.."))
      ((title . ,(date->string date "~m"))
       (url   . "../.."))
      ((title . ,(date->string date "~d")))
      ((title . ,(assq-ref post 'slug)))))

  (define new-content
    `((main
        (article
          (h1
            (a (@ (href  ".")
                  (title ,(format #f "Permalink to ~A" (assq-ref post 'title)))
                  (rel   "bookmark"))
              ,(assq-ref post 'title)))
          (header
            ;; Draft status notification
            ,(if (and status (eq? status 'draft))
              '(aside (@ (class "alert alert-info" )
                         (role "alert"))
                 (strong "Draft:")
                 "This article is in draft status, set the "
                 (code "status")
                 " metadatum to "
                 (code "published")
                 " when ready.")
              '())
            ;; Date of the blog post
            (p
              (time (@ (class "published")
                       (datetime ,(date->string date "~1")))
                "Published: " ,(date->string date "~1")))
            ,(if modified
              `(p
                 "Modified: "
                 (time (@ (datetime ,(date->string modified "~1")))
                   ,(date->string modified "~1")))
              '())
           ,(if category
              `(p
                 "Category: "
                 (a (@ (href ,(format #f "../../../../categories/~A" (assq-ref category 'url))))
                   ,(assq-ref category 'title)))
               '())
           ,(if (null? tags)
              '()
              `(p
                 "Tags: "
                 ,@(map tag->sxml tags))))
           ,@content
           ))
      ,(if (or prev next)
         (pager->sxml prev next)
         '())))

  (define metadata
    `((content     . ,new-content)
      (breadcrumbs . ,breadcrumbs)
      (css         . ,css)))
  (append metadata data))

(define (pager->sxml prev next)
  "Build the SXML tree for the pager of a blog post."
  (define (item->sxml item rel symbol next?)
    (define title (assq-ref item 'title))
    (define url   (assq-ref item 'url  ))
    `(a (@ (href ,(format #f "../../../../~A" url))
           (rel  ,rel)
         (style ,(format #f "float: ~A" (if next? "right" "left"))))
       ,@(if next?
           `(,title
             " "
             (span (@ (aria-hidden "true"))
               ,symbol))
           `((span (@ (aria-hidden "true"))
               ,symbol)
             " "
             ,title))))

  `(nav (@ (class "blog-pager"))
     ,(if prev
        (item->sxml prev "previous" "←" #f)
        '(a (@ (hidden "hidden"))
           ""))
     ,(if next
        (item->sxml next "next" "→" #t)
        '(a (@ (style "display: none;"))
           ""))))

(define (tag->sxml tag)
  (define title (assq-ref tag 'title))
  (define url   (assq-ref tag 'url  ))
  `(a (@ (href ,(format #f "../../../../tags/~A" (assq-ref tag 'url))))
     ,(format #f "~A " title)))
