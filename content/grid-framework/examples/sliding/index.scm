#!/usr/bin/guile
!#

(use-modules (content grid-framework examples index))

(example-page
  "Sliding puzzle"
  "sliding"
  '(p "Unit's built-in physics system is great for 3D games with realistic
      behaviour, but sometimes you need more basic predictable and
      \"video-gamey\" behaviour. This example doesn't use physics at all,
      instead it keeps track of which squares are occupied and which are free,
      then it restricts movement accordingly by clamping the position
      vector."))

