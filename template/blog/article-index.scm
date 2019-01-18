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


(define-module (template blog article-index)
  #:use-module ((srfi srfi-19)
                #:select (date->string))
  #:export (article-index articles-list))

(define (article-index data)
  "Template for an article index; article indices list articles for a give
group (e.g. a category). The content is a sequence of articles, usually showing
their title with a link to the full article, and a preview of the full
article.

Required metadata:

   - pages    Number of pages in the paginator
   - page     Number of the current pagination page
   - content  The content generated from the previous template (list of post
              previews)"
  (define pages   (assq-ref data 'pages  ))
  (define page    (assq-ref data 'page   ))
  (define content (assq-ref data 'content))
  
  (define css '("/css/article_index.css"))
  (define new-content
    `((h1 "Articles of the blog")
      (main
        (ul
          ,@content))
      ,(if (> pages 1)
         `(footer
            (nav (@ (class "paginator text-center"))
              (ul (@ (class "pagination"))
                ,@(paginator page pages))))
         '())
      ))

  (acons 'content new-content
         (acons 'css css data)))

(define (articles-list posts relative-to)
  "Build the items for display in an article index. The result is a list of
`li` elements to be spliced into an `ul` or `ol`."

  (define (post->sxml post)
    "Converts one post object into an SXML tree."
    (define title    (assq-ref post 'title   ))
    (define url      (assq-ref post 'url     ))
    (define date     (assq-ref post 'date    ))
    (define modified (assq-ref post 'modified))
    `(li
       (article
         (h1
           (a (@ (href ,(string-append relative-to url)))
             ,title))
         (header
           (p
             (time (@ (datetime ,(date->string date "~1")))
               "Published: "
               ,(date->string date "~1")))
           ,(if modified
              `(p
                 (time (@ (datetime ,(date->string modified "~1")))
                   "Modified: "
                   ,(date->string modified "~1")))
              '()))
         ;; The summary is the first item of the content-tree (usually a paragraph)
         ,(list-head (assq-ref post 'content) 1)
         ;; Display a link if there is more content than what fit into the preview
         ,(if (not (null? (list-tail (assq-ref post 'content) 1)))
            `(p
               (a (@ (href ,(string-append relative-to url)))
                 "Continue reading…"))
            '()))))

  (map post->sxml posts))

(define (paginator current-page total-pages)
  "Build the items of the paginator at the bottom. Each item is a `li`, the
result is a list to be spliced in."
  (define* (page-index->sxml index #:optional (label #f))
    "Convert a page and its index to a paginator entry."
    `(li (@ (class ,(if (= index current-page) "active" "")))
       ,(if (= index current-page)
          ;; Only display the number, but don't make it a hyperlink
          `(a 
             ,(format #f "~A" index))
          ;; Make it a hyperlink
          `(a (@ (href ,(cond
                          ((= 1 current-page) (format #f "./~A/" index))
                          ((= 1        index) "..")
                          (else (format #f "../~A/" index)))))
             ,(if label label (format #f "~A" index))))))

  ; (format #t "Page ~A/~A~%" current-page total-pages)

  (cond
    ;; If there are fewer than eight pages display them all
    ((< total-pages 8)
     (map page-index->sxml (range 1 total-pages)))
    ;; There are more than eight pages, but we are still in the first batch
    ((< current-page 5)
     `(;; Display a previous item if We are not on the first page
       ,(if (> current-page 1)
          (page-index->sxml (1- current-page) `(span (@ (aria-hidden "true")) "‹"))
          '())
       ;; The first seven pages
       ,(map page-index->sxml (range 1 7))
       ;; The next page
       ,(page-index->sxml (1+ current-page) `(span (@ (aria-hidden "true")) "›"))
       ;; The last page
       ,(page-index->sxml total-pages `(span (@ (aria-hidden "true")) "»"))))
		;; Similar to the previous case, but in the last batch
    ((> current-page (- total-pages 4))
     `(;; The first page
       ,(page-index->sxml 1 `(span (@ (aria-hidden "true")) "«"))
       ;; The previous page
       ,(page-index->sxml (1- current-page) `(span (@ (aria-hidden "true")) "‹"))
       ;; The last seven pages
       ,(map page-index->sxml (range (- total-pages 6) total-pages))
       ;; Display a next page if we are not on the last page
       ,(if (< current-page total-pages)
          (page-index->sxml (1+ current-page) `(span (@ (aria-hidden "true")) "›"))
          '())))
    ;; Somewhere in the middle, display everything
    (else
     `(;; The first page
       ,(page-index->sxml 1 `(span (@ (aria-hidden "true")) "«"))
       ;; The previous page
       ,(page-index->sxml (1- current-page) `(span (@ (aria-hidden "true")) "‹"))
       ;; ...
       ,(map page-index->sxml (range (- current-page 3) (+ current-page 3)))
       ;; The next page
       ,(page-index->sxml (1+ current-page) `(span (@ (aria-hidden "true")) "›"))
       ;; The last page
       ,(page-index->sxml total-pages `(span (@ (aria-hidden "true")) "»"))))))

(define (range from to)
  "Produce a list of integers `from` to `to` (both inclusive)"
  (define (iter from to accu)
    (if (zero? (- to from))
      (cons from accu)
      (iter from (1- to) (cons to accu))))
  (iter from to '()))
