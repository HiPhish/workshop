#!/usr/bin/guile
!#

(use-modules (content grid-framework examples index))

(example-page
  "Moving along a grid"
  "movement"
  '(p
     "Use the arrow keys to move. The hero cannot pass through walls and he
     cannot step on water. The walls are entries inside the map of the level,
     the water is outside the map.")
  '(p
     "This example demonstrates one of the simplest and most common uses for
     Grid Framework: converting between coordinate systems. We take the
     object's current position, convert is to grid space, add a direction to
     it, convert the result back to world space and use that as the
     destination of our movement function.")
  '(pre
     (code
       "var goal = grid.WorldToGrid(transform.position)\n"
       "goal += Vector3.right;\n"
       "transform.position = grid.GridToWorld(goal);\n"))
  '(p
     "This on its own is not that interesting, so let's limit the player to
     the visible region of the grid. Every grid is infinitely large, but the "
     (em "renderer")
     " has a range we can use as limits before converting back to world
     coordinates:")
  '(pre
     (code
       "if (goal.x < _renderer.From.x || goal.x > _renderer.To.x)\n"
       "    return;\n"
       "if (goal.y < _renderer.From.y || goal.y > _renderer.To.y)\n"
       "    return;"))
  '(p
     "As a final touch, let's use Grid Framework to store the map of the game.
     It will know which tiles are OK to walk on and which ones are obstacles.
     We will use a 2D array to keep track of the game; each entry's row and
     column corresponds to the tile's X- and Y coordinates in the grid.")
  '(pre
     (code
       "// After checking for range, before converting to world coordinates\n"
       "if (!FreeTile(_goal)) {\n"
       "    return;\n"
       "}\n"
       "\n"
       "// Building the matrix\n"
       "var rows    = Mathf.FloorToInt(_renderer.To.x);\n"
       "var columns = Mathf.FloorToInt(_renderer.To.y);\n"
       "\n"
       "_tiles = new bool[rows, columns];\n"
       "\n"
       "// Checking a tile (grid coordinates)\n"
       "var r = Mathf.FloorToInt(tile.x);\n"
       "var c = Mathf.FloorToInt(tile.y);\n"
       "return _tiles[r, c];\n")))
