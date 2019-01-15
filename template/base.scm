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
  (define content   (assq-ref data 'content  ))

  (define new-content
    `(html (@ (lang "en"))
       ,(head-snippet #:title title #:css css #:style style)
       (body
         (h1 "HTML-page body")
         (header
           ;; Top navigation bar
           ,(main-navbar site-name menu-bar))
         (section (@ (class "container"))
           (h1 "Document body")
           ;; -- insert sub-navigation here ---
           ,@content)
         ;; Footer of the website
         (footer
           (div (@ (class "container"))
             (div (@ (class "col-md-8 footer-self"))
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
                      `(p (@ (class "text-muted"))
                         ,(if image
                            `(a (@ (href ,url))
                               (img (@ (class "copyright-image")
                                       (src ,image)
                                       (alt ,title)))
                               " ")
                            "")
                         ,@note)))))
             (div (@ (class "col-md-4 footer-social"))
               (span (@ (class "pull-right"))
                 ,@(map (λ (item)
                          `(a (@ (href ,(assq-ref item 'url))
                                 (title ,(assq-ref item 'title))
                                 (target "blank"))
                             (img (@ (class "img-circle")
                                     (src   ,(assq-ref item 'image))
                                     (alt   ,(assq-ref item 'title))))
                             " "))
                        (assq-ref footer 'social)))))))))

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
     ;; Bootstrap customisation
     (link (@ (rel "stylesheet" )
              (href "/css/custom.css")
              (type "text/css" )
              (media "all")))
     ;; My own style sheets
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
    (cond
      ((list? item)
       `(li (@ (class "dropdown"))
          (a (@ (class "dropdown-toggle")
                (href ,url)
                (data-toggle "dropdown")
                (role "button")
                (aria-haspopup "true")
                (aria-expanded "false"))
            ,title)
          (ul (@ (class "dropdown-menu"))
            ,@(map (λ (sub-item)
                      (cond
                        ((null? sub-item)
                         '(li (@ (class "divider")
                                 (role "separator"))
                            ""))
                        (else
                          `(li
                             (a (@ (href ,(assq-ref sub-item 'url)))
                               ,(assq-ref sub-item 'title))))))
                   (assq-ref item 'items)))))
      (else
        `(li
           (a (@ (href ,url))
             ,(assq-ref item 'title))))))

  `(nav (@ (id "main-navbar")
           (class "navbar navbar-default"))
     (h1 "Site-wide navigation bar")
     ;; Brand and toggle get grouped for better mobile display
     (div (@ (class "container-fluid"))
       (input (@ (type "checkbox")
                 (value "")
                 (name "navbar-toggle-cbox")
                 (id "navbar-toggle-cbox")))
       ;; Brand and toggle get grouped for better mobile display
       (div (@ (class "navbar-header"))
         (label (@ (for "navbar-toggle-cbox" )
                   (class "navbar-toggle collapsed")
                   (data-toggle "collapse")
                   (data-target "#main-navbar-collapse")
                   (aria-controls "navbar-toggle-cbox"))
           (span (@ (class "sr-only")) "Toggle navigation")
           (span (@ (class "icon-bar")) "")
           (span (@ (class "icon-bar")) "")
           (span (@ (class "icon-bar")) ""))
         (a (@ (class "navbar-brand")
               (href "/"))
          ,home))

       ;; Collect the nav links, forms, and other content for toggling
       (div (@ (class "collapse navbar-collapse")
               (id "main-navbar-collapse"))
         ;; The list of navbar items
         (ul (@ (class "nav navbar-nav"))
           ,@(map menu-item->sxml
                  (assq-ref menu 'left)))
         (ul (@ (class "nav navbar-nav navbar-right"))
           ,@(map (λ (menu-item)
                    `(li
                       (a (@ (href ,(assq-ref menu-item 'url)))
                         ,(assq-ref menu-item 'title))))
                  (assq-ref menu 'right)))))))
