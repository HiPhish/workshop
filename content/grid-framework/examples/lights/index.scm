#!/usr/bin/guile
!#

(use-modules (content grid-framework examples index))

(make-example-page
  "Lights Out"
  "lights"
  '(p "Click a tile and all adjacent tiles swap their colour, the player's goal
      is to turn off all lights. This example uses events and delegates to make
      all tiles compare their grid position to the clicked one's grid position
      to decide whether to swap colours. The tiles themselves don't know
      anything about the rest of the grid."))

