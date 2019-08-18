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

(define-module (generator blog archive)
  #:use-module ((generator)
                #:select (generate-file))
  #:use-module ((generator templated)
                #:select (templated-generator))
  #:use-module ((template base)         #:select (base-page))
  #:use-module ((template page)         #:select (page))
  #:use-module ((template blog)         #:select (blog))
  #:use-module ((template blog archive) #:select (archive))
  #:export (generate-archive))

(define template
  (compose base-page page blog archive))

(define (generate-archive out-dir data)
  (define blog (assq-ref data 'blog))

  (define out-file (string-append out-dir
                                  (assq-ref blog 'url)
                                  "archive/index.html"))
  (generate-file out-file '() (templated-generator template data)))
