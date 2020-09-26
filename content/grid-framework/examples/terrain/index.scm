#!/usr/bin/guile
!#

(use-modules (content grid-framework examples index))

(example-page
  "Terrain mesh generation"
  "terrain"
  '(p "Left-click a vertex to raise it, right click to lower it. The text field
      visualises the state of the terrain matrix."))
