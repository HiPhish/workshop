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

;; Useful links:
;;
;;   - Description of the Atom format
;;     https://validator.w3.org/feed/docs/atom.html
;;
;;   - Atom feed specification (RFC 4287)
;;     https://tools.ietf.org/html/rfc4287

(define-module (generator blog feed)
  #:use-module ((sxml simple)
                #:select (sxml->xml sxml->string))
  #:use-module ((srfi srfi-19)
                #:select (current-date date-zone-offset date->string))
  #:export (generate-feeds))

(define (generate-feeds out-dir data)
  "Generate all for the blog (only RSS for now, but adding Atom is easy)."
  (generate-rss  out-dir data))

(define (generate-rss out-dir data)
  "Generate the RSS feed XML file."
  (define blog (assq-ref data 'blog))
  (define url  (assq-ref blog 'url))

  (define rss
    `(rss (@ (version "2.0"))
       (channel
         (title ,(assq-ref blog 'title))
         (link ,(string-append (assq-ref data 'url)
                               (assq-ref blog 'url)))
         (description ,(assq-ref blog 'description))
         (language "en")
         (docs "https://cyber.harvard.edu/rss/rss.html")
         (lastBuildDate ,(date->rfc-822 (current-date)))
         ,@(map (λ (post) (post->item post blog data))
                (assq-ref data 'posts)))))
  (call-with-output-file (string-append out-dir url "rss.xml")
    (λ (out)
      (format out "<?xml version=\"1.0\" encoding=\"UTF-8\"?>~%")
      (sxml->xml rss out))))

(define (generate-atom out-dir data)
  "Generate the Atom feed XML file."
  (define blog (assq-ref data 'blog))
  (define url  (assq-ref blog 'url))

  (define feed
    `(feed (@ (xmlns "http://www.w3.org/2005/Atom"))
       (title ,(assq-ref blog 'title))
       (link (@ (href ,(string-append (assq-ref data 'url)
                                      (assq-ref blog 'url)))
                (rel "self")))
       (updated ,(date->rfc-3339 (current-date)))
       (author
         (name ,(assq-ref blog 'author)))
       (id ,(string-append (assq-ref data 'url)
                           (assq-ref blog 'url)))
       ,@(map (λ (post) (post->entry post blog data))
              (assq-ref data 'posts))
       ))

  (call-with-output-file (string-append out-dir url "atom.xml")
    (λ (out)
       (format out "<?xml version=\"1.0\" encoding=\"UTF-8\"?>~%")
       (sxml->xml feed out))))


;; ---[ RSS auxiliary procedures ]---------------------------------------------
(define (date->rfc-822 date)
  "Convert a date to a string according to RFC 822 for use with RSS. See
https://www.ietf.org/rfc/rfc822.txt"
  (date->string date "~a, ~d ~b ~Y ~H:~M:~S ~z"))

(define (post->item post blog data)
  `(item
     (title ,(assq-ref post 'title))
     (link  ,(string-append
               (assq-ref data 'url)
               (assq-ref blog 'url)
               (assq-ref post 'url)))
     (description ,(sxml->string (car (assq-ref post 'content))))
     ;; TODO: pubDate
     (pubDate ,(date->rfc-822 (assq-ref post 'date)))
     (category ,(assq-ref post 'category))))


;; ---[ Atom auxiliary procedures ]--------------------------------------------
(define (date->rfc-3339 date)
  "Convert a date to a string according to RFC 3339 for use with Atom. See
https://tools.ietf.org/html/rfc3339"
  ;; The time zone format is not according to the RFC, so we have to change
  ;; "+0100" to "+01:00" instead
  (define offset (date-zone-offset date))
  (define zone (format #f "~a~2,'0d:00" (if (< offset 0) "-" "+") (abs (/ offset 100))))

  (string-append (date->string date "~1T~3")
                 zone))

(define (post->entry post blog data)
  `(entry
     (title (@ (type "xhtml"))
       (div (@ (xmlns "http://www.w3.org/1999/xhtml"))
         ,(assq-ref post 'title)))
     (link (@ (href ,(string-append
                       (assq-ref data 'url)
                       (assq-ref blog 'url)
                       (assq-ref post 'url)))))
     (published ,(date->rfc-3339 (assq-ref post 'date)))
     (updated ,(or (date->rfc-3339 (or (assq-ref post 'modified)
                                       (assq-ref post 'date)))))
     (id ,(string-append (assq-ref data 'url)
                         (assq-ref blog 'url)
                         (assq-ref post 'url)))
     (category (@ (term ,(assq-ref post 'category))))
     (summary (@ (type "xhtml"))
       (div (@ (xmlns "http://www.w3.org/1999/xhtml"))
         ,@(assq-ref post 'content)))
     ))
