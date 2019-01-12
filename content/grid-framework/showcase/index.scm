#!/usr/bin/guile
!#

(define metadata
  '((title    . "Showcase - Grid Framework")
    (sub-site . grid-framework)
    (css      . ("/css/magnific-popup.css" "/css/magnific-popup-custom.css"))))

(define (showcase->sxml title url img description author)
  "Build up an SXML tree of a showcased game's description."
  `(div (@ (class "row showcase")
           (style "margin-bottom: 3em;"))
     (div (@ (class "col-md-4 showcase-pic"))
       (a (@ (href ,(string-append "img/" img)))
         (img (@ (class "group1 img-responsive")
                 (src ,(string-append "img/" img))
                 (alt ,title)))))
     (div (@ (class "col-md-8"))
       (h2
         (a (@ (href ,url))
           ,title))
       (blockquote
         (p ,description)
         (footer ,author)))))

(define titles
  '("MYMMO" "Shallow Space" "Sinkr"))

(define urls
  '("http://forums.tigsource.com/index.php?topic=50706.msg1185371"
    "http://shallow.space"
    "https://wahler.digital/"))

(define imgs
  '("mymmo.png" "shallow-space.jpg" "sinkr.png"))

(define authors
  '("Aaron John-Baptiste, Gravity Apple"
    "James Martin, Special Circumstances"
    "Robert Wahler, Wahler Digital"))

(define descriptions
  '("MYMMO is a Sim City inspired city builder with a twist: you are the designer
of an MMO RPG. Grid Framework is an instrumental part of the world building
toolset, I was able to get grid snapping and zoning tools working with minimal
hassle, love it."
    "Shallow Space is an 3D RTS, we use the grid framework to add perspective to
the scene and it works great!"
    "Sinkr is a minimalist puzzle game with an ambient sound track that responds
to your actions.  I use the Grid Framework to layout the levels, do runtime
positional snapping, and use the Vectrosity support to overlay the visible grid
guides."))

(define content
  `((h1 "Made using Grid Framework")
    (p
      "Take a look at what existing customers think of Grid Framework and what
       they used it for to give you an idea of the different ways to employ
       Grid Framework.")
    (hr)
    ,@(map showcase->sxml titles urls imgs descriptions authors)
    (hr)
    (p
      "If you want your own game featured on this page drop me a line with a few
       sentences describing your game and how Grid Framework helped you during
       development.")
    (p
      (em "General disclaimer:")
      " The author of Grid Framework is only associated with the authors of the
       games displayed on this page through Grid Framework. Games are chosen
       arbitrarily based on their suitability to demonstrate the diverse
       applications of use; the inclusion of a game is neither an endorsement,
       nor is the exclusion of a game a condemnation.")
    ;; Script required for Magnific Popup
    (script (@ (src "/js/jquery.magnific-popup.js")
               (type "text/javascript")
               (charset "utf-8"))
      "")
    (script (@ (type "text/javascript"))
      "$(document).ready(function() {
        $('.showcase-pic').magnificPopup({
          delegate: 'a',
          type: 'image',
          mainClass: 'mfp-with-zoom',
          key: 'showcase',
          gallery: {
            enabled:true,
          },
          zoom: {
            enabled: true,
            duration: 200,
            easing: 'ease-in-out',
            opener: function(openerElement) {
              return openerElement.is('img') ? openerElement : openerElement.find('img');
            }
          }
        });
      })")))

(acons 'content content metadata)
