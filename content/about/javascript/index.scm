(use-modules (component static-page))

(define (js-entry->sxml name license my-url original-url license-url)
  "Build up an SXML table entry from information about a JavaScript source
file."
  `(tr
     (td
       (a (@ (href ,my-url))
         ,name))
     (td
       (a (@ (href ,license-url))
         ,license))
     (td
       (a (@ (href ,original-url))
         ,name))))

;; Use this information to build up the table for Javascript files
(define javascript
  ;; name license my-url original-url license-url
  '(("bootstrap.min.js"
     "Expat"
     "/js/bootstrap.min.js"
     "https://getbootstrap.com/"
     "http://www.jclark.com/xml/copying.txt")
    ("jquery.min.js"
     "X11"
     "/js/jquery.min.js"
     "https://github.com/jquery/jquery"
     "http://www.xfree86.org/3.3.6/COPYRIGHT2.html#3")
    ("jquery.prettyPhoto.js"
     "GPLv2"
     "/js/jquery.prettyPhoto.js"
     "http://www.no-margin-for-errors.com/projects/prettyphoto-jquery-lightbox-clone/"
     "http://www.gnu.org/licenses/gpl-2.0.html")
    ("web-player.js"
     "Expat"
     "/js/web-player-object.js"
     ""
     "http://www.jclark.com/xml/copying.txt")
    ("web-player-object.js"
     "Expat"
     "/js/web-player-object.js"
     ""
     "http://www.jclark.com/xml/copying.txt")
    ("navbar.js"
     "Expat"
     "/js/navbar.js"
     "/js/navbar.js"
     "http://www.jclark.com/xml/copying.txt")))

(static-page ((title "HiPhish's Workshop - Javascript"))
  (p
    "The following is a list of all JavaScript scripts employed on this page.")
  (table (@ (class "table")
            (id    "jslicense-labels1"))
    ,@(map (λ (js-entry) (apply js-entry->sxml js-entry)) javascript)))
