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


(define-module (template blog categories)
  #:export (categories))

(define (categories data)
  "Concrete template for all categories in the blog. Does not generate any
actual content, only sets up the metadata for the next step in the pipeline.

Required metadata:
  - blog        Information about the blog
  - categories  List of association list of categories"

  (define blog       (assq-ref data 'blog))
  (define categories (assq-ref data 'categories))

  (define breadcrumbs
    `(((title . ,(assq-ref blog 'top))
       (url   . "../"))
      ((title . "categories"))))
  (define content
    `((ul
        ,@(map category->sxml categories))))
  (define metadata `((content     . ,content)
                     (title       . "Categories")
                     (url         . "categories")
                     (breadcrumbs . ,breadcrumbs)))
  (append metadata data))

(define (category->sxml category)
  (define title (assq-ref category 'title))
  (define url   (assq-ref category 'url  ))
  `(li 
     (a (@ (href ,url))
        ,title)
     ,(format #f " (~A)" (length (assq-ref category 'posts)))))
