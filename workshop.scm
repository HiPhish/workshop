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

;;; ===========================================================================
;;;    WEBSITE GENERATION  (where we tie everything together)
;;; ===========================================================================
;;;
;;; Global settings and configuration for the site generation process. The
;;; generation will be run from here.

(use-modules ((ice-9 getopt-long) #:select (getopt-long option-ref))
             ((generator blog)    #:select (generate-blog))
             ((config)            #:select (base-data))
             ((workshop static)   #:select (generate-static-content)))

(define (main args)
  ;; Get command-line options
  (define option-spec '((url (value #t))))
  (define options (getopt-long args option-spec))

  ;; Actual website generation starts here
  (define data (acons 'url (option-ref options 'url "") base-data))
  (define blogs (assq-ref data 'blogs))

  (generate-static-content data "content" "output"
                           (map (λ (blog)
                                  (string-append "content" (assq-ref blog 'url)))
                                blogs))
  (for-each (λ (blog)
              (define sub-site )
              (generate-blog blog
                             "content"
                             "output"
                             (acons 'sub-site (assq-ref blog 'sub-site)
                                    data)))
            blogs))
