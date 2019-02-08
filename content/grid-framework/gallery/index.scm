#!/usr/bin/guile
!#

(define metadata
  '((title    . "Gallery - Grid Framework")
    (sub-site . grid-framework)
    (css      . ("gallery.css" "/css/magnific-popup.css" "/css/magnific-popup-custom.css"))))

(define (gallery-item->sxml img caption alt)
  `(li
     (a (@ (title ,caption)
           (href  ,(string-append "img/" img))
           (class "thumbnail"))
       (img (@ (src   ,(string-append "img/" img))
               (class "group1")
               (alt   ,alt))))))

(define gallery-items
  ;; Image URL, caption, alternative text
  '(("grids.png"
     "Adding a grid to the scene is as easy as assigning any other component in Unity."
     "Four kinds of grids: rectangular, spherical, polar and hexagonal")
    ("renderers.png"
     "Renderers display the grid in the scene; use one of the existing ones or write your own."
     "Customizable grid renderers")
    ("documentation.png"
     "The user manual explains the components and how to use them, the scripting reference covers every part of the API."
     "User manual and reference manual included")
    ("menu-bar.png"
     "No menu clutter, everything fits inside Unity as it should."
     "Menu items are integrated into Unity's menus")
    ("lights.png"
     "The included example shows how a grid can be used as a common base of communication between unrelated objects."
     "Example included: lights-out game")
    ("movement.png"
     "Use grids to compute way-points for grid-based movement."
     "Example included: movement and snapping")
    ("infinite.png"
     "Adjust the range of grid renderer on the fly to create the illusion of an infinitely scrolling grid."
     "Example included: infinitely scrolling grid")
    ("terrain.png"
     "Generate a mesh from simple data by converting the data to world-coordinates."
     "Example included: generate mesh from data")
    ("level.png"
     "Place objects in the world based on grid coordinates."
     "Example included: build levels from data")
    ("dial.png"
     "Use the grid coordinates of a point to drive an animation script"
     "Example included: rotary dial")
    ("vectrosity.png"
     "Users of Vectrosity can have the lines of renderer generate with one method call"
     "Vectrosity support")))

(define content
  `((p
      "Click on one of the thumbnails to see the full image or mouse over for
      the description. The examples shown here are all included with Grid
      Framework.  Please keep in mind that the  Vectrosity example requires you
      to own a Vectrosity license.")
    (ul (@ (class "gallery thumbnails"))
       ,@(map (λ (gallery-item) (apply gallery-item->sxml gallery-item))
              gallery-items))
    (script (@ (type "text/javascript")
               (src "/js/jquery.magnific-popup.js")
               (charset "utf-8"))
      "")
    (script (@ (type "text/javascript"))
      "$(document).ready(function() {
           $('.gallery').magnificPopup({
             delegate: 'a',
             type: 'image',
             key: 'screenshots',
             mainClass: 'mfp-with-zoom',
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

(acons 'content content
       (acons 'js '("https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js")
              metadata))
