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

(use-modules ((haunt serve web-server)
              #:select (serve)
              #:prefix haunt:)
             ((ice-9 getopt-long)
              #:select (getopt-long option-ref)))

(define (main args)
  "Main function of the server, to be called from the command-line with
command-line arguments.

Supported arguments
  --port  Port to run the local server from"
  ;; Get command-line options
  (define options (getopt-long args '((port (value #t)))))

  (let ((port (option-ref options 'port #f)))
    (if port
      (serve port)
      (serve))))

(define* (serve #:optional (port 8080) (host "0.0.0.0"))
  "Run the local web server. Really just a wrapper around the Haunt server."
  (haunt:serve "output" #:open-params `(#:port ,port #:host ,host)))
