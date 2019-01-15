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


(define-module (template blog tags)
  #:export (tags))

(define (tags data)
  "Template for all tags in the blog. Does not generate any actual content,
only sets up the metadata for the next step in the pipeline.

Required metadata:
  - blog  Information about the blog
  - tags  List of association list of tags"

  (define blog       (assq-ref data 'blog))
  (define tags (assq-ref data 'tags))

  (define breadcrumbs
    `(((title . ,(assq-ref blog 'top))
       (url   . "../"))
      ((title . "tags"))))
  (define content
    `((ul
        ,@(map tag->sxml tags))))
  (define metadata `((content     . ,content)
                     (breadcrumbs . ,breadcrumbs)
                     (title       . "Tags")
                     (url         . "tags")))
  (append metadata data))

(define (tag->sxml tag)
  (define title (assq-ref tag 'title))
  (define url   (assq-ref tag 'url  ))
  `(li 
     (a (@ (href ,url))
        ,title)
     ,(format #f " (~A)" (length (assq-ref tag 'posts)))))
