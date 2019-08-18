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

(define-module (generator blog tags)
  #:use-module ((rnrs lists) #:version (6)
                #:select (find))
  #:use-module ((generator)
                #:select (generate-file))
  #:use-module ((generator templated)
                #:select (templated-generator))
  #:use-module ((template base)      #:select (base-page))
  #:use-module ((template page)      #:select (page))
  #:use-module ((template blog)      #:select (blog))
  #:use-module ((template blog tags) #:select (tags))
  #:export (generate-tags add-tags))

(define template
  (compose base-page page blog tags))

(define (generate-tags output-dir data)
  "Generate the index of all tags of the blog."
  (define blog (assq-ref data 'blog))
  (define out-file
    (string-append output-dir
                   (assq-ref blog 'url)
                   "tags/index.html"))
  (generate-file out-file '() (templated-generator template data)))

(define (add-tags data)
  "Add the tags from the posts to the metadata."
  (define tags (get-tags (assq-ref data 'posts)))
  (acons 'tags tags data))

(define (get-tags posts)
  "Return the list of tags collected from the `posts`. Each tag is an
association list with the following keys:

  - title  The name of the tag
  - key    The URL of the tag relative to the root of the blog
  - posts  A list of posts with this tag"
  (define tags '())
  (do ((posts posts (cdr posts)))
      ((null? posts) tags)
    (let ((post (car posts)))
      (do ((post-tags (assq-ref post 'tags) (cdr post-tags)))
          ((or (not post-tags) (null? post-tags)) tags)
        (let* ((tag (car post-tags))
               (entry (find (λ (t) (string=? tag (assq-ref t 'title))) tags)))
          (if entry
            ;; Add a new post to the tag
            (append! (assq-ref entry 'posts) (list post))
            ;; Create a new tag
            (set! tags
              (cons `((title . ,tag)
                      (url   . ,(format #f "~A/" tag))
                      (posts . ,(list post)))
                    tags))))))))
