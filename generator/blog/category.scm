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

(define-module (generator blog category)
  #:use-module ((generator)
                #:select (build-page))
  #:use-module ((generator templated)
                #:select (templated-generator))
  #:use-module ((template base)          #:select (base-page))
  #:use-module ((template page)          #:select (page))
  #:use-module ((template blog)          #:select (blog))
  #:use-module ((template blog article-index) #:select (article-index))
  #:use-module ((template blog category) #:select (category))
  #:export (generate-category))

(define template
  (compose base-page page blog article-index category))

(define *posts-per-page* 10)

(define (generate-category out-dir data)
  "Generate all index pages for a given category."
  (define category (assq-ref data 'category))
  (define blog     (assq-ref data 'blog    ))

  (define url (format #f "~Acategories/~A" (assq-ref blog 'url) (assq-ref category 'url)))
  (define posts (assq-ref category 'posts))
  (define post-count (length posts))
  (define page-count (+ (quotient post-count *posts-per-page*)
                        (if (zero? (remainder post-count *posts-per-page*))
                          0
                          1)))

  (do ((current-page 1 (1+ current-page)))
      ((> current-page page-count))
    (let* ((tail (list-tail posts (* (1- current-page) *posts-per-page*)))
           (head (list-head tail (min (length tail) *posts-per-page*))))
        (generate-one-category-page
          (if (= 1 current-page)
            (format #f "~A/~Aindex.html" out-dir url)
            (format #f "~A/~A~A/index.html" out-dir url current-page))
          (acons 'page current-page
                 (acons 'pages page-count
                        (acons 'posts head data)))))))

(define (generate-one-category-page out-file data)
  "Generate one index page for a given category (out of possibly many)."
  (build-page out-file '() (templated-generator template data)))
