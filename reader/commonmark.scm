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

(define-module (reader commonmark)
  #:use-module ((haunt reader)
                #:select (reader-proc))
  #:use-module ((haunt reader commonmark)
                #:select (commonmark-reader))
  #:export (read-from-commonmark))

(define proc
  (reader-proc commonmark-reader))

(define (read-from-commonmark file-path)
  (define-values (metadata content) (proc file-path))
  (acons 'content content metadata))
