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


(define-module (template base)
  #:export (base-page)
  #:use-module ((srfi srfi-19)
                #:select (current-date date-year)))

;;; The base template is the final step in content production, it wraps
;;; everything in the markup used on the entire page.

(define (base-page data)
  "Build a complete page, ready for rendering as HTML. The content is a list of
SXML expressions which will be spliced in. The metadata is an association
list."
  (define site-name (assq-ref data 'site-name))
  (define title     (assq-ref data 'title    ))
  (define menu-bar  (assq-ref data 'menu-bar ))
  (define css       (assq-ref data 'css      ))
  (define style     (assq-ref data 'style    ))
  (define footer    (assq-ref data 'footer   ))
  (define lang      (assq-ref data 'lang     ))
  (define content   (assq-ref data 'content  ))

  (define new-content
    `(html (@ (lang ,lang))
       ,(head-snippet #:title title #:css css #:style style)
       (body
         (header
           ;; Top navigation bar
           ,(main-navbar site-name menu-bar))
         (div
           ;; -- insert sub-navigation here ---
           ,@content)
         ;; Footer of the website
         (footer
           (div  ; This is a wrapper to limit the width
             (div (@ (class "footer-self"))
               ,(let ((logo (assq-ref footer 'logo)))
                  (if (not logo)
                    ""
                    (let ((title (assq-ref logo 'title))
                          (image (assq-ref logo 'image))
                          (url   (assq-ref logo   'url)))
                      `(a (@ (href ,url)
                             (title ,title))
                         (img (@ (src ,image)
                                 (title ,title)))))))
               ,(let ((copyright (assq-ref footer 'copyright)))
                  (if (not copyright)
                    ""
                    (let ((note  (assq-ref copyright  'note))
                          (title (assq-ref copyright 'title))
                          (image (assq-ref copyright 'image))
                          (url   (assq-ref copyright   'url)))
                      `(p
                         ,(if image
                            `(a (@ (href ,url))
                               (img (@ (class "copyright-image")
                                       (src ,image)
                                       (alt ,title)))
                               " ")
                            "")
                         ,@note)))))
             (div (@ (class "footer-social"))
               ,@(map (λ (item)
                        `(a (@ (href ,(assq-ref item 'url))
                               (title ,(assq-ref item 'title))
                               (target "blank"))
                           (img (@ (src   ,(assq-ref item 'image))
                                   (alt   ,(assq-ref item 'title))))
                           " "))
                      (assq-ref footer 'social)))
           )))))

  (acons 'content new-content data))

(define* (head-snippet #:key (title #f) (css #f) (style #f) (js '()))
  "Produce the `head` part of the base page. Returns one SXML expression (which
   may of course contain sub-expressions), not a list of SXML expressions."
  `(head
     (meta (@ (charset "utf-8")))
     (meta (@ (name "viewport")
              (content "width=device-width, initial-scale=1")))
     (title ,(if title title "HiPhish's Workshop"))
     ;; Bootstrap integration
     (link (@ (rel "stylesheet")
              (href "https://maxcdn.bootstrapcdn.com/bootswatch/3.3.7/flatly/bootstrap.min.css")
              (crossorigin "anonymous")))
     ;; My own style sheets
     (link (@ (rel "stylesheet")
              (href "/css/main.css")
              (type "text/css")
              (media "all")))
     (link (@ (rel "stylesheet")
              (href "/css/local-nav.css")
              (type "text/css")
              (media "all")))
     (link (@ (rel "stylesheet")
              (href "/css/pygments.css")
              (type "text/css")
              (media "all")))
     ;; Extra CSS from metadata
     ,(map (λ (url)
		         `(link (@ (rel "stylesheet")
		                   (href ,url)
		                   (type "text/css")
		                   (media "all"))))
           (if css css '()))
     ;; Extra style information embedded into the page
     ,(map (λ (style) `(style ,style))
           (if style style '()))
     ;; jQuery (necessary for Bootstrap's JavaScript plugins) -->
     (script (@ (src "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"))
       "")
     ;; Bootstrap Javascript
     (script (@ (src "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js")
                (integrity "sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa")
                (crossorigin "anonymous"))
       "")
     ;; Extra Javascript from metadata
     ,(map (λ (url)
             `(script (@ (src ,url)) ""))
           js)))

(define (main-navbar home menu)
  "Generate the SXML tree of the main menu navigation bar"

  (define (menu-item->sxml item)
    (define title (assq-ref item 'title))
    (define url   (assq-ref item 'url  ))
    (define items (assq-ref item 'items))
    ;; If the li is empty it is a separator, so it needs to be hidden
    `(li ,(if (or url items) '() '(@ (hidden "hidden")))
       ,(if url
          `(a (@ (href ,url)) ,title)
          title)
       ,(if items
          `(ul
             ,@(map menu-item->sxml items))
          '())))

  (define (push-end items)
    "Push the first li of the list towards the end."
    (define head (car items))
    (cons `(li (@ (class "push-end"))
              ,(cdr head))
          (cdr items)))

  `(nav (@ (id "main-navbar"))
     ;; input and label work together for the hamburger hack
     (input (@ (type "checkbox")
               (id   "main-nav-hamburger")
               (hidden "hidden")))
     (div  ; Contains the header of the navbar
       (a (@ (href "/"))
         ,home)
       (label (@ (for "main-nav-hamburger")
                 (hidden "hidden"))
         ""))
     (ul
       ,(map menu-item->sxml (assq-ref menu 'left))
       ,(push-end (map menu-item->sxml (assq-ref menu 'right))))))
