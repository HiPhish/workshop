;;; Copyright 2020 Alejandro "HiPhish" Sanchez
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

(define-module (component template)
  #:export (template))

;;; A template takes page data and transforms it into (potentially) other page
;;; data. Page data is a dictionary structure (here an association list) where
;;; the key is the name of a particular datum (such as the title).
;;;
;;; A template reads some entries from its input data and writes entries to the
;;; output data. It may overwrite existing entries or add new entries. For
;;; example, a template might alter the title of a page or add page-specific
;;; CSS files to the page.

;;; The DSL allows us to specify which entries we want to read from the input
;;; data and what entries to add to the output. The first argument is a list of
;;; entry keys to bind. The remainder are (key value) pairs of entries to add.
;;; The values can refer to input values through the above defined bindings.

(define-syntax-rule
  (template (binding ...)
    (field-expr value)
    ...)
  (λ (data)
    (define binding (assq-ref data (quote binding)))
    ...
    ;; Note: if a binding and a field expression are the same, subsequent
    ;; values will use the binding, not the field expression.
    (let ((field-expr value)
          ...)
      (cons*
        (cons (quote field-expr) field-expr)
        ...
        data))))
