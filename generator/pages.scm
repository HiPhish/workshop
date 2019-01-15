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

(define-module (generator pages)
  #:use-module ((ice-9 regex)
                #:select (string-match match:substring))
  #:use-module ((ice-9 ftw)
                #:select (file-system-fold))
  #:use-module ((reader scheme)
                #:select (read-from-scheme))
  #:use-module ((generator templated)
                #:select (templated-generator))
  #:use-module ((template base)
                #:select (base-page))
  #:use-module ((template page)
                #:select (page))
  #:use-module ((generator)
                #:select (build-page))
  #:use-module ((generator verbatim)
                #:select (verbatim-generator))
  #:export (generate-pages))

;; ============================================================================
;; GENERATING THE REGULAR PAGES
;; ============================================================================
;; Walk the content directory, skipping over directories of blogs. At each leaf
;; decide what to do: Scheme files are processed through the templates, regular
;; files are copied over.
;;
;; The initial value of the fold is the base metadata, which will be returned
;; as the result. We do not change the metadata, but we make use of it within
;; the leaf nodes.
;; ----------------------------------------------------------------------------

(define (enter? path stat result skip-directories)
  "Only enter a directory if it is not the path of a blog."
  (not (member (string-append path "/") skip-directories)))

(define (leaf path stat result output-dir content-dir)
  (define extension  ; File extension with leading dot stripped
    (string-drop (match:substring (string-match "\\.[^.]*$" path)) 1))
  (cond
    ((char=? #\. (string-ref (basename path) 0))  ; Skip dot files
     result)
    ((string=? extension "scm")
     (let ((data (read-from-scheme path))
           (out-file (string-append output-dir
                                    (substring path
                                               (string-length
                                                  content-dir)
                                               (- (string-length path)
                                                  3))
                                    "html")))
       (build-page out-file (list path)
                   (templated-generator (compose base-page page)
                                        (append data result))))
     result)
    (else
      (let ((out-file (string-append output-dir
                                     (substring path
                                                (string-length
                                                  content-dir)))))
        (build-page out-file (list path)
                    (verbatim-generator path)))
      result)))

(define (error path stat errno result)
  result)

(define (nothing path stat result)
  "Do nothing at this node."
  result)

(define (generate-pages content-dir output-dir metadata)
  (define blog-directories
    (map (λ (blog)
           (string-append content-dir (assq-ref blog 'url)))
         (assq-ref metadata 'blogs)))
  (file-system-fold (λ (path stat result)
                      (enter? path stat result blog-directories))
                    (λ (path stat result)
                       (leaf path stat result output-dir content-dir))
                    nothing
                    nothing
                    nothing
                    error
                    metadata
                    content-dir))
