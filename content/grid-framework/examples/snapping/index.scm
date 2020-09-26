#!/usr/bin/guile
!#

(use-modules (content grid-framework examples index))

(example-page
  "Runtime snapping"
  "snapping"
  '(p "Click and drag a block over the grid and observe how it snaps to the
			grid's cells. The mouse input is handled by casting a ray from the cursor
			through the camera into the grid and seeing where it hits the grid's
			collider."))
