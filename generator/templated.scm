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

(define-module (generator templated)
  #:use-module ((sxml simple)
                #:select (sxml->xml))
  #:export (templated-generator))

(define (templated-generator template data)
  "Produce a generator which applies a template to metadata and content."
  (λ (out-file)
    (define content (assq-ref (template data) 'content))
    (call-with-output-file out-file
      (λ (out)
        (sxml->xml content out)))))
