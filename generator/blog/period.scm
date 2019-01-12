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

(define-module (generator blog period)
  #:use-module ((srfi srfi-19)
                #:select (date-year date-month date-day))
  #:use-module ((generator)
                #:select (build-page))
  #:use-module ((generator templated)
                #:select (templated-generator))
  #:use-module ((template base)          #:select (base-page))
  #:use-module ((template page)          #:select (page))
  #:use-module ((template blog)          #:select (blog))
  #:use-module ((template blog article-index) #:select (article-index))
  #:use-module ((template blog period) #:select (period))
  #:export (generate-periods add-periods))

(define template
  (compose base-page page blog article-index period))

(define (generate-periods out-dir data)
 (do ((periods (assq-ref data 'periods) (cdr periods)))
      ((null? periods))
    (let ((year (car periods)))
      (generate-year-archive out-dir (car year) data)
      (do ((periods (cdr year) (cdr periods)))
          ((null? periods))
        (let ((month (car periods)))
          (generate-month-archive out-dir (car year) (car month) data))))))


(define (add-periods data)
  "Enrich the data with the periods association tree."
  (acons 'periods (get-periods data) data))

(define (generate-year-archive out-dir year data)
  "Generate all index pages for a given year."
  (define blog (assq-ref data 'blog))
  (define posts
    (apply append (map (λ (month)
                         (cdr month))
                       (assv-ref (assq-ref data 'periods) year))))
  (define metadata
    `((year  . ,year)
      (posts . ,(filter (λ (p) (post-from-year? p year)) (assq-ref data 'posts)))
      (pages . 1)
      (page  . 1)))
  (define out-file (format #f "~A~A~A/index.html" out-dir (assq-ref blog 'url) year))

  (build-page
    out-file
    '() ;; TODO: add dependency on the source directory
    (templated-generator template (append metadata data))))

(define (generate-month-archive out-dir year month data)
  "Generate all index pages for a given month of a given year."
  (define blog (assq-ref data 'blog))
  (define posts (assv-ref (assv-ref (assq-ref data 'periods) year) month))
  (define metadata
    `((year  . ,year)
      (month . ,month)
      (posts . ,posts)
      (pages . 1)
      (page  . 1)))
  (define out-file (format #f "~A~A~A/~2,'0d/index.html" out-dir (assq-ref blog 'url) year month))

  (build-page
    out-file
    '() ;; TODO: add dependency on the source directory
    (templated-generator template (append metadata data))))


;; ----------------------------------------------------------------------------
(define (post-from-year? post year)
  "Whether the date of a `post` is from the `year`."
  (= year (date-year (assq-ref post 'date))))

(define (post-from-month? post month)
  "Whether the date of a `post` is from the `month` (regardless of year)."
  (= month (date-month (assq-ref post 'date))))


(define (get-periods data)
  "Return the periods of the blog. The result is an association list with years
(as integers) for keys and another association list for value. The inner
association list has months (as integers) for keys and a list of posts for
values.

Example: '((2018 . ((03 . (post-1
                           post-2))
                    (08 . (post-3
                           post-4))))
           (2017 . ((05 . (post-5)))))"

  (define (post->year  post) (date-year  (assq-ref post 'date)))
  (define (post->month post) (date-month (assq-ref post 'date)))
  (define (post->day   post) (date-day   (assq-ref post 'date)))

  (define periods '())
  ;; Loop over all posts and build the periods association tree.
  (do ((posts (assq-ref data 'posts) (cdr posts)))
      ((null? posts) periods)
    (let* ((post (car posts))
           (year         (post->year  post))
           (month        (post->month post))
           ;; Alist of month-entries
           (period-year  (assv-ref periods year))
           ;; List of posts for this month
           (period-month (and period-year (assv-ref period-year month))))
      (cond
        ((not period-year)
         (set! periods
           (assv-set! periods year
                      `((,month . ,(list post))))))
        ((not period-month)
         (set! periods
           (assv-set! periods year
                      (assv-set! period-year month
                                 (list post)))))
        (else
          (set! periods
            (assv-set! periods year
                       (assv-set! period-year month
                                  (cons post period-month)))))))))
