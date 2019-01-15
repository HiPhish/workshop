#!/usr/bin/guile
!#

(use-modules (content grid-framework examples index))

(make-example-page
  "Assembling a level from data"
  "level"
  '(p
     "Click to the button to cycle through level layouts.")
  '(p
     "The core of this example is the position of a entries in the array, i.e.
     the row and column.  We use these array coordinates as grid coordinates
     and convert them to world coordinates.")
  '(pre
     (code
       "HexGrid grid;     // The grid we use for out game\n"
       "int column, row;  // Given data in grid coordinates\n"
       "\n"
       "var  gridPosition = new Vector3(column, row, 0);\n"
       "var worldPosition = Grid.GridToWorld(grid-position);")))
