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

(define-module (component static-page)
  #:export (static-page))

;;; Turn this:
;;;
;;;   (static-page ((title "My first page")
;;;                 (css   '("main.css")))
;;;     (h1 "This is a heading")
;;;     (p "This is a paragraph")
;;;     (p ,(string-append "The title is: " title)))
;;;
;;; into this:
;;;
;;;   '((title . "My first page")
;;;     (css . '("main.css"))
;;;     (content . ((h1 "This is a heading")
;;;                 (p "This is a paragraph")
;;;                 (p "The title is: My first page"))))

(define-syntax-rule
  (static-page ((meta-datum value)
                ...)
    content-expr
    ...)
  "Static page DSL macro

This macro defines a static website with a syntax similar to Scheme's
let*-expressions. The first argument is a list of (BINDING VALUE) bindings, the
body is the content of the page.

The bindings are used as metadata of the page. The BINDING is the name of the
particular metadatum and gets quoted automatically. The VALUE is evaluated
normally. Later BINDINGs can reference prior bindings.

The body is a sequence of S-XML elements. Each item is automatically
QUASIQUOTEd, so it is possible to use UNQUOTE inside each expression. The
metadata BINDINGs established above are available.

The macro expands into an association list. The entries are the metadata
'(BINDING . VALUE) pairs, and a special pair '(content . CONTENT), where
CONTENT is a list of all content expressions."
  (let* ((meta-datum value)
         ...)
    (list
      (cons (quote meta-datum) meta-datum)
      ...
      (cons (quote content) (list (quasiquote content-expr)
                                  ...)))))
