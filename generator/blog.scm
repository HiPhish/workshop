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

(define-module (generator blog)
  #:use-module ((ice-9 regex)
                #:select (string-match match:substring))
  #:use-module ((ice-9 ftw)
                #:select (file-system-fold))
  #:use-module ((srfi srfi-19)
                #:select (make-date date-year date-month date-day date->string string->date))
  #:use-module ((reader commonmark) #:select (read-from-commonmark))
  #:use-module ((reader     scheme) #:select (read-from-scheme))
  ; Commented out for the time being because the module (haunt reader skribe)
  ; cannot be found.
  ; #:use-module ((reader     skribe) #:select (read-from-skribe))
  #:use-module ((generator)
                #:select (generate-file))
  #:use-module ((generator verbatim)
                #:select (verbatim-generator))
  #:use-module ((generator blog post)
                #:select (generate-posts))
  #:use-module ((generator blog index)
                #:select (generate-index))
  #:use-module ((generator blog category)
                #:select (generate-category))
  #:use-module ((generator blog tag)
                #:select (generate-tag))
  #:use-module ((generator blog categories)
                #:select (generate-categories add-categories))
  #:use-module ((generator blog tags)
                #:select (generate-tags add-tags))
  #:use-module ((generator blog period)
                #:select (generate-periods add-periods))
  #:use-module ((generator blog archive)
                #:select (generate-archive))
  #:use-module ((generator blog feed)
                #:select (generate-feeds))
  #:export (generate-blog))


;; ============================================================================
;; GENERATING THE BLOGS
;; ============================================================================
;; Walk the file tree of the blog directories, at each leaf node decide what to
;; do: copy regular files over, process special files (Scheme, Markdown, and so
;; on). We need two passes: the first pass builds up the metadata of the entire
;; blog, but does not write any pages. Then we can build the special pages like
;; archives. Finally, we make a second pass and this time we write the blog
;; post pages.
;; ----------------------------------------------------------------------------

(define *posts-per-page* 10)

;; ============================================================================
;;  FILE-TREE-WALK
;; ============================================================================
(define slug-regex
  (make-regexp "(.+)(\\.[^.]+)"))
(define date-regex
  (make-regexp "/([0-9][0-9][0-9][0-9])/([0-9][0-9])/([0-9][0-9])$"))

(define (file-path->slug path)
  "Infer the implicit slug from the file path"
  (define match (regexp-exec slug-regex (basename path)))
  (match:substring match 1))

(define (file-path->date path)
  "Infer the implicit date from the file path"
  (define match (regexp-exec date-regex (dirname path)))
  (define year  (match:substring match 1))
  (define month (match:substring match 2))
  (make-date 0 0 0 0  ;nsecs seconds minutes hours
             (string->number (match:substring match 3))  ; day
             (string->number (match:substring match 2))  ; month
             (string->number (match:substring match 1))  ; year
             0))  ; zone-offset

(define (read-post reader path)
  "Read a post by applying the `reader` procedure to the `path`. Infer metadata
if necessary."
  (define data (reader path))
  ;; Infer implicit metadata from the path
  (unless (assq-ref data 'date)
    (set! data (acons 'date (file-path->date path) data)))
  (unless (assq-ref data 'slug)
    (set! data (acons 'slug (file-path->slug path) data)))
  (unless (assq-ref data 'category)
    (set! data (acons 'category "misc" data)))
  (unless (assq-ref data 'tags)
    (set! data (acons 'tags '() data)))
  (unless (assq-ref data 'url)
    (set! data (acons 'url (format #f "~A/~A/"
                                   (date->string (assq-ref data 'date)
                                                 "~Y/~m/~d")
                                   (assq-ref data 'slug))
                      data)))
  (let ((modified (assq-ref data 'modified)))
    (when modified
      (set! data
        (acons 'modified (string->date modified "~Y-~m-~d") data))))
  data)

(define (enter? path stat result)
  "Always enter every directory."
  #t)

(define (leaf path stat result output-dir content-dir)
  "Copy regular files verbatim, for special files read them, get the metadata
and the first item, add it to the result, and throw the rest away."

  (define (add-post post)
    "Add a new post to the list of posts in the data. Creates the list if
necessary."
    (define posts (assq-ref result 'posts))
    (assq-set! result 'posts
                    (cons post (if posts posts '()))))

  (define extension  ; File extension with leading dot stripped
    (string-drop (match:substring (string-match "\\.[^.]*$" path)) 1))

  (cond
    ((char=? #\. (string-ref (basename path) 0))
     result)
    ((string=? "md" extension)
     ;; Read the data from the blog post, enrich the result with it
     (add-post (read-post read-from-commonmark path)))
    ((string=? "scm" extension)
     (add-post (read-post read-from-scheme path)))
    ; Commented out for the time being because the module (haunt reader skribe)
    ; cannot be found.
    ; ((string=? "skr" extension)
    ;  (add-post (read-post read-from-skribe path)))
    (else
      (let ((out-file (string-append output-dir
                                     (substring path
                                                (string-length
                                                  content-dir)))))
        (generate-file out-file (list path)
                       (verbatim-generator path)))
      result)))

(define (error path stat errno result)
  result)

(define (nothing path stat result)
  "No nothing at this node."
  result)
;; ============================================================================

;; ===[ MISCELLANEOUS STUFF ]==================================================
(define (post<? post1 post2)
  (define date1 (assq-ref post1 'date))
  (define date2 (assq-ref post2 'date))
  (cond
    ((< (date-year  date1) (date-year  date2)) #t)
    ((> (date-year  date1) (date-year  date2)) #f)
    ((< (date-month date1) (date-month date2)) #t)
    ((> (date-month date1) (date-month date2)) #f)
    ((< (date-day   date1) (date-day   date2)) #t)
    ((> (date-day   date1) (date-day   date2)) #f)
    (else #f)))
;; ============================================================================


;; ============================================================================
;;  BLOG GENERATION
;; ============================================================================


(define (get-blog-content-data content-dir output-dir blog)
  "Return all the aggregated data from the blog, i.e. all posts, periods and so
on. This only includes data from the blog content, not data which yet needs to
be generated, like the categories or periods."
  (define url    (assq-ref blog 'url))
  (define root   (string-append content-dir url))
  (define output (string-append  output-dir url))
  (define blog-data
    (file-system-fold enter?
                      (λ (path stat result)
                        (leaf path stat result output root))
                      nothing
                      nothing
                      nothing
                      error
                      '()
                      root))
  blog-data)


(define (generate-blog blog content-dir output-dir metadata)
  "Generate an entire blog. Call this procedure once for each blog."
  (define data
    (append (get-blog-content-data content-dir output-dir blog)
            metadata))
  (set! data
    (acons 'blog blog data))
  ;; Sort posts in descending order
  (set! data
    (assq-set! data 'posts
               (sort (assq-ref data 'posts) (λ (p1 p2) ; reverse order
                                              (post<? p2 p1)))))
  (set! data (add-categories data))
  (set! data (add-tags       data))
  (set! data (add-periods    data))

  (generate-index      "output" data)
  (generate-categories "output" data)
  (generate-tags       "output" data)
  (generate-periods    "output" data)
  (generate-archive    "output" data)
  (generate-posts      "output" data)
  (generate-feeds      "output" data)

  (do ((categories (assq-ref data 'categories) (cdr categories)))
      ((null? categories))
    (generate-category "output"
                       (acons 'category (car categories)
                              data)))
  (do ((tags (assq-ref data 'tags) (cdr tags)))
      ((null? tags))
    (generate-tag "output"
                  (acons 'tag (car tags)
                         data)))

  #t)
