#!/usr/bin/guile
!#

(define images
  '("analogue-data-disc-117729.jpg"
    "black-black-and-white-cubes-37534.jpg"))
(define urls
  '("https://www.pexels.com/photo/analogue-business-close-up-computer-117729/"
    "https://www.pexels.com/photo/6-pieces-of-black-and-white-dice-37534/"))

(define (image&url->sxml image url)
  `(li (a (@ (href ,url)))
      ,image))


(define content
  `((h1 "Image attributions")
    (p
      "The images in this directory are taken from the following sources. If an
      image is not listed, then it is my own original creation")
    (ul
      ,@(map image&url->sxml images urls))))

`((content . ,content))
