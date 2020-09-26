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


(define-module (template blog index)
  #:use-module (component template)
  #:use-module ((template blog article-index)
                #:select (articles-list))
  #:export (index))

;;; Template for the blog main index, to be spliced into the blog template.
;;;
;;; The main index of the blog is what the user first sees when visiting the
;;; blog.  It displays all articles (paginated of course) from newest to
;;; oldest.

(define index
  (template (blog posts page)
    (breadcrumbs
      `(((title . ,(assq-ref blog 'top)))))
    (content
      (articles-list posts (if (= page 1)
                             ""
                             "../")))))
