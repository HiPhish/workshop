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

(define-module (generator blog categories)
  #:use-module ((rnrs lists) #:version (6)
                #:select (find))
  #:use-module ((generator)
                #:select (generate-file))
  #:use-module ((generator templated)
                #:select (templated-generator))
  #:use-module ((template base)            #:select (base-page))
  #:use-module ((template page)            #:select (page))
  #:use-module ((template blog)            #:select (blog))
  #:use-module ((template blog categories) #:select (categories))
  #:export (generate-categories add-categories))

(define template
  (compose base-page page blog categories))

(define (generate-categories output-dir data)
  "Generate the index of all categories of the blog."
  (define blog (assq-ref data 'blog))
  (define out-file
    (string-append output-dir
                   (assq-ref blog 'url)
                   "categories/index.html"))
  (generate-file out-file '() (templated-generator template data)))

(define (add-categories data)
  "Add the categories from the posts to the metadata."
  (define categories (get-categories (assq-ref data 'posts)))
  (acons 'categories categories data))

(define (get-categories posts)
  "Return a list of categories collected from the `posts`. Each category is an
association list with the following keys:

  - title  The name of the category
  - key    The URL of the category relative to the root of the blog
  - posts  A list of posts in this category"
  
  (define categories '())
  (do ((posts posts (cdr posts)))
      ((null? posts) categories)
    (let* ((post (car posts))
           (cat  (assq-ref post 'category))
           (entry (find (λ (c) (string=? cat (assq-ref c 'title))) categories)))
      (if entry
        ;; Add the new post
        (append! (assq-ref entry 'posts) (list post))
        ;; Create a new category
        (set! categories
          (cons `((title . ,cat)
                         (url   . ,(format #f "~A/" cat))
                         (posts . ,(list post)))
                categories))))))
