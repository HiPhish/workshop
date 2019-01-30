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

(define-module (template page)
  #:use-module ((srfi srfi-19)
                #:select (date->string))
  #:export (page))
;; A page is a generic template for all static pages, and one step below the
;; base template. Technically the page- and base template could have been
;; merged into one.


(define (page data)
  "Base template for all pages, to be spliced into a web page."

  (define title     (assq-ref data 'title    ))
  (define sub-site  (assq-ref data 'sub-site ))
  (define sub-sites (assq-ref data 'sub-sites))
  (define modified  (assq-ref data 'modified ))
  (define content   (assq-ref data 'content  ))


  (define new-content
    `(,(if sub-site
         (sub-site-navigation (assq-ref sub-sites sub-site))
         '())
      (section
        ,@content)
      ,(if modified
         `(footer (@ (class "col-md-12"))
            (p "Last updated: " (date->string modified "~1")))
         "")))

  (acons 'content new-content
         (if (and sub-site title)
           ;; Set the title of the page if there is a sub-site
           (acons 'title (string-append title
                                        "-"
                                        (assq-ref (assq-ref sub-sites sub-site)
                                                  'title))
                  data)
           data)))

(define (sub-site-navigation sub-site)
  (define title (assq-ref sub-site 'title))
  (define url   (assq-ref sub-site 'url  ))
  (define items (assq-ref sub-site 'items))

  `(nav (@ (class "local-nav"))
     (h1 "Sub-site navigation bar")
     (ul
       (li
         (a (@ (href ,url))
           ,title))
       ,@(map (λ (item)
                (define title (assq-ref item 'title))
                (define url   (assq-ref item 'url  ))
                `(li
                   ;; TODO: highlight the current item
                   (a (@ (href ,url))
                     ,title)))
              items))))
