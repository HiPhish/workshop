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


(define-module (template blog category)
  #:use-module (component template)
  #:use-module ((template blog article-index)
                #:select (articles-list))
  #:export (category))

(define category
  (template (blog category posts page)
    (breadcrumbs
      `(((title . ,(assq-ref blog 'top))
         (url   . "../../"))
        ((title . "categories")
         (url   . "../"))
        ((title . ,(assq-ref category 'title)))))
    (content
      (articles-list posts (if (= page 1) "../../" "../../../")))))
