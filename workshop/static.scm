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

(define-module (workshop static)
  #:use-module ((ice-9 ftw)           #:select (file-system-fold))
  #:use-module ((ice-9 regex)         #:select (string-match match:substring))
  #:use-module ((reader scheme)       #:select (read-from-scheme))
  #:use-module ((generator)           #:select (build-page))
  #:use-module ((generator templated) #:select (templated-generator))
  #:use-module ((generator verbatim)  #:select (verbatim-generator))
  #:use-module ((template base)       #:select (base-page))
  #:use-module ((template page)       #:select (page))
  #:export (generate-static-content))

(define (generate-static-content data content output blacklist)
  "Walk the CONTENT directory and write the generated files into the OUTPUT
director, ignoring directories from the BLACKLIST."

  (define (void path stat result)
    "A procedure which does nothing."
    result)

  (file-system-fold
    (λ (path stat result)        ; enter?
      "Only enter a directory if it is not a path in the blacklist."
      (not (member (string-append path "/") blacklist)))
    (λ (path stat result)        ; leaf
      (leaf path stat result output content))
    void                         ; down
    void                         ; up
    void                         ; skip
    (λ (path stat errno result)  ; error
      result)
    data                         ; init
    content))

(define (leaf path stat result output-dir content-dir)
  "When encountering a leaf node perform an action based on the extension of
the file.

Dot files are skipped, Scheme files are compiled to HTML files, and all other
files are copied verbatim."

  (define extension  ; File extension with leading dot stripped
    (string-drop (match:substring (string-match "\\.[^.]*$" path)) 1))

  (cond
    ((char=? #\. (string-ref (basename path) 0))  ; Skip dot files
     result)
    ((string=? extension "scm")
     (let ((data (read-from-scheme path))
           (out-file (string-append output-dir
                                    (substring path
                                               (string-length
                                                  content-dir)
                                               (- (string-length path)
                                                  3))
                                    "html")))
       (build-page out-file (list path)
                   (templated-generator (compose base-page page)
                                        (append data result))))
     result)
    (else
      (let ((out-file (string-append output-dir
                                     (substring path
                                                (string-length
                                                  content-dir)))))
        (build-page out-file (list path)
                    (verbatim-generator path)))
      result)))
