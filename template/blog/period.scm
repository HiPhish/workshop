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

(define-module (template blog period)
  #:use-module (component template)
  #:use-module ((template blog article-index)
                #:select (articles-list))
  #:export (period))

;;; Template for a period archive for a given period (year or month). For any
;;; period the preceding periods must be also give, i.e. if we want to generate
;;; a monthly archive we also need the year of the month. On the other hand, a
;;; yearly archive does not need a month, it will list the posts for all
;;; months.
;;; 
;;; Required metadata:
;;; 
;;;   - blog   Information about the blog (will be propagated up)
;;;   - posts  The list of posts to display
;;;   - year   Topmost period (integer)
;;;   
;;; More lesser periods (e.g. the month) can be given, but they are optional.

(define period
  (template (blog year month posts)
    (breadcrumbs
      (cond
        (month `(((title . ,(assq-ref blog 'top))
                  (url   . "../../"))
                 ((title . ,year)
                  (url   . "../"))
                 ((title . ,(format #f "~2,'0d" month)))))
        (else `(((title . ,(assq-ref blog 'top))
                 (url   . "../"))
                ((title . ,year))))))
    (content
      (articles-list posts (if month
                             "../../"
                             "../")))))
