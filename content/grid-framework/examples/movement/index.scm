#!/usr/bin/guile
!#

(use-modules (content grid-framework examples index))

(make-example-page
  "Moving along a grid"
  "movement"
  '(p "Use the arrow keys to move. The hero cannot pass through walls and he
      cannot step on water. The walls are entries inside the map of the level,
      the water is outside the map."))
