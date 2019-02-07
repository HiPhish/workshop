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

(define-module (template blog)
  #:use-module ((srfi srfi-1)
                #:select (fold))
  #:export (blog))

;; The blog template is a wrapper for all blog-related pages (individual
;; articles, archives, categories,...). A blog page itself may be further
;; processed by other templates.

(define (blog data)
  "Base template for all blog-related pages, the result is to be spliced into a
page.

Required metadata:

  - content     The content to display in the middle of the page, e.g. an
                entire blog post, a listing of categories or a listing of blog
                post previews.

  - blog        Metadata about the current blog to process.
             
  - categories  Association list of categories. The key is the name of the
                category (a string), the value is a list of posts in that
                category.
                
  - tags        The same as categories, except for tags."

  (define breadcrumbs (assq-ref data 'breadcrumbs))
  (define content     (assq-ref data 'content    ))
  (define categories  (assq-ref data 'categories ))
  (define tags        (assq-ref data 'tags       ))
  (define blog        (assq-ref data 'blog       ))
  (define periods     (assq-ref data 'periods    ))
  (define blog-url    (assq-ref blog 'url        ))

  (define (breadcrumb->sxml item)
    "Convert a breadcrumb entry from the items to an SXML tree"
    (define title (assq-ref item 'title))
    (define url   (assq-ref item 'url  ))
    `(li (@ (class ,(if url "" "active")))
       ,(if url
          `(a (@ (href ,url))
             ,title)
          title)))

  (define (category->sxml category)
    "Convert an item from the categories alist into an SXML tree."
    (define title (assq-ref category 'title))
    (define url   (assq-ref category 'url  ))
    (define posts (assq-ref category 'posts))
    `(li
       (a (@ (href ,(string-append blog-url "categories/" url)))
         ,(format #f "~A (~A)" title (length posts)))))

  (define (tag->sxml tag)
    "Convert an item from the tags alist into an SXML tree."
    (define title (assq-ref tag 'title))
    (define url   (assq-ref tag 'url  ))
    (define posts (assq-ref tag 'posts))
    `(li
       (a (@ (href ,(string-append blog-url "tags/" url)))
         ,(format #f "~A (~A)" title (length posts)))))

  (define (period->sxml year)
    `(li
       (a (@ (href ,(format #f "~A~A/" blog-url (car year))))
         ,(format #f "~A (~A)"
                  (car year)
                  (fold + 0 (map (λ (month) (length (cdr month))) (cdr year)))))))

   (define new-content
     `((div (@ (class "blog"))
         (nav (@ (class "breadcrumbs")
                 (aria-label "Breadcrumbs"))
           (ol
             ,@(map breadcrumb->sxml breadcrumbs)))
         ,@content
         ;; Left pillar, article navigation
         (nav (@ (class "blog-navigation")
                 (aria-label "Blog navigation"))
           ;; This navigator contains links to the various archive types.
           (aside
             (span "Subscribe:")
             " "
             (a (@ (href ,(string-append blog-url "rss.xml"))
                   (type "application/rss+xml"))
               "RSS")
             ; ", "
             ; (a (@ (href ,(string-append blog-url "atom.xml"))
             ;       (type  "application/atom+xml"))
             ;   "Atom")
             )
           (nav
             (h1
               (a (@ (href ,(format #f "~Aarchive/" blog-url)))
                 "Archive"))
             (ul
               ; For each year display a year link to that year's archive. If the
               ; year is the year of the current post display a sub-list for that year
               ,@(reverse!
                   (map period->sxml periods))))
           (nav
             (h1
               (a (@ (href ,(string-append blog-url "categories/")))
                 "Categories"))
             (ul
               ,@(map category->sxml categories)))
           (nav
             (h1
               (a (@ (href ,(string-append blog-url "tags/")))
                 "Tags"))
             (ul
               ,@(map tag->sxml tags)))))))

   ;; Add the new extra CSS to the data as necessary, but first add the new content
   (let ((css (assq-ref data 'css))
         (data (acons 'content new-content data)))
     (acons 'css (cons "/css/blog.css" (if css css '())) data)))
