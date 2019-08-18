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

(define-module (generator blog index)
  #:use-module ((generator)
                #:select (generate-file))
  #:use-module ((generator templated)
                #:select (templated-generator))
  #:use-module ((template base)
                #:select (base-page))
  #:use-module ((template page)
                #:select (page))
  #:use-module ((template blog)
                #:select (blog))
  #:use-module ((template blog article-index)
                #:select (article-index))
  #:use-module ((template blog index)
                #:select (index))
  #:export (generate-index))

(define *posts-per-page* 10)

(define template
  (compose base-page page blog article-index index))

(define (generate-index out-dir data)
  "Generate the entire index of the blog, split over multiple pages if necessary."
  (define blog (assq-ref data 'blog))
  (let* ((number-of-posts (length (assq-ref data 'posts)))
         (pages (+ (quotient number-of-posts *posts-per-page*)
                   (if (zero? (remainder number-of-posts *posts-per-page*)) 0 1))))
    (do ((page 1 (1+ page)))
        ((> page pages))
      (let* ((posts (assq-ref data 'posts))
             (tail (list-tail posts (* (1- page) *posts-per-page*)))
             (head (list-head tail (min (length tail) *posts-per-page*))))
        (generate-one-index-page
          (if (= 1 page)
            (string-append out-dir (assq-ref blog 'url) "index.html")
            (format #f "~A~A~A/index.html" out-dir (assq-ref blog 'url) page))
          (acons 'pages pages
                 (acons 'page page
                        (acons 'posts head data))))))))

(define (generate-one-index-page out-file data)
  "Generate one index page of the blog (out of possibly many)."
  (generate-file out-file '() (templated-generator template data)))
