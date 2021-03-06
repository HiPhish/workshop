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


(define-module (template blog archive)
  #:use-module (component template)
  #:export (archive))

;;; The global archive which lists all post in chronological order, but without
;;; preview.
(define archive
  (template (blog periods)
    (breadcrumbs
      `(((title . ,(assq-ref blog 'top))
         (url   . "../"))
        ((title . "archive"))))
    (content
      `((main (@ (id "archive"))
          (ul
            ,@(reverse! (map year->sxml periods))))))))

(define (year->sxml year)
  `(li
     (a (@ (href ,(format #f "../~A/" (car year))))
       ,(format #f "~A" (car year)))
     (ul
       ,@(reverse! (map (λ (m) (month->sxml (car year) m)) (cdr year))))))

(define (month->sxml year month)
  "Convert a month period to an SXML tree."
  (define month-table
    '(( 1 . "January")
      ( 2 . "February")
      ( 3 . "March")
      ( 4 . "April")
      ( 5 . "May")
      ( 6 . "June")
      ( 7 . "July")
      ( 8 . "August")
      ( 9 . "September")
      (10 . "October")
      (11 . "November")
      (12 . "December")))
  `(li
     (a (@ (href ,(format #f "../~A/~2,'0d/" year (car month))))
       ,(assv-ref month-table (car month)))
     (ul
       ,@(reverse! (map post->sxml (cdr month))))))

(define (post->sxml post)
  "Convert a post to an SXML tree."
  `(li
     (a (@ (href ,(string-append "../" (assq-ref post 'url))))
       ,(assq-ref post 'title))))
