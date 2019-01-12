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

;;; Top-level site generator procedures, the ones that actually write files to
;;; disc

(define-module (generator)
  #:export (build-page))

(define* (build-page out-file dependencies generator #:optional (force? #f))
  "Build a web page (or any other file) `out-file` according to the `generator`
thunk. Only rebuild the file if it is older than any of its `dependencies` or
`force?` is true."
  (when (file-needs-rebuild? out-file dependencies force?)
    (mkdir-p (dirname out-file))
    (generator out-file)))

(define* (mkdir-p path #:optional (mode #f))
  "Creates a new directory like `mkdir`, but creating intermediate directories
if necessary. Similar to `mkdir -p` in the shell, hence the name."
  (if (access? path W_OK)
    #t
    (begin
      (mkdir-p (dirname path) mode)
      (if mode
        (mkdir path mode)
        (mkdir path)))))

(define* (file-needs-rebuild? fname dependencies #:optional (force? #f))
  "Whether a given target file with given dependency files needs to be rebuilt.

A file needs to be rebuilt if it does not exists, if the templates have been
changed, or if it's older than any one of its dependencies."
  (cond
    (force? #t)
    ((not (access? fname W_OK)) #t)
    (else
      (let ((modtime (stat:mtime (stat fname))))
        (cond
          ((> modtime (stat:mtime (stat "template"))) #t)
          (or-map (λ (dependency)
                (> (stat:mtime (stat dependency))
                   modtime))
        dependencies))))))
