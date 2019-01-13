#!/usr/bin/guile
!#

;; We want to use this module in subsequent examples, so we make it available
;; together with a procedure which generates the content for a given example
;; page.
(define-module (content grid-framework examples index)
  #:export (make-example-page))

(define (make-example-page title id . body)
  "Build the entire web page for one of the example pages. This function
generates the metadata and the content, so the module using this only has to
call this one function."
  (define metadata
    `((title    . ,(string-append title " - Grid Framework"))
      (sub-site . grid-framework)
      (css      . ("/css/web-player.css"))
      (js       . ("/js/unity-webgl.js"))))

  (define content
    `(;; Assets built by Unity for the HTML5 player
      (link (@ (href "Release/example.datagz")))
      (link (@ (href "Release/example.jsgz")))
      (link (@ (href "Release/example.asm.jsgz")))
      (link (@ (href "Release/example.memgz")))
      (p (@ (class "backlink"))
        (a (@ (href ,(string-append "../#" id)))
          "Grid Framework examples")
        " | "
        (strong ,title))
      ,@body
      (canvas (@ (id "canvas")
                 (oncontextmenu "event.preventDefault()")
                 (height "450")
                 (width "600"))
        "")
      (script (@ (src "../example.js")
                 (type "text/javascript"))
        "")
      (script (@ (src "Release/UnityLoader.js"))
        "")))
  (acons 'content content metadata))

(define (example->sxml title url video content)
  "Build a list of SXML expressions of an example to splice into the content
tree."
  `(,(if video
       `(iframe (@ (title "YouTube video player")
                   (src   ,video)
                   (class "pull-right"))
          "")
       '())
    (h1 (@ (id ,url))
      (a (@ (href ,(string-append url "/")))
        ,title))
    ,@content))

(define example-titles
  '("Moving along a grid"
    "Lights-out puzzle game"
    "Assembling a level from data"
    "Runtime snapping"
    "Seemingly endless grid"
    "Terrain mesh generation"
    "Rotary dial"
    "Sliding puzzle"
    "Snake game"
    "Vectrosity support"))

(define example-urls
  '("movement" "lights" "level-design" "snapping" "endless"
    "terrain"  "dial"   "sliding"      "snake"    "vectrosity")) 

(define example-videos
  '("http://www.youtube.com/embed/m9_efVi_tFs"
    "http://www.youtube.com/embed/sXlagrglfQ8"
    "http://www.youtube.com/embed/lvYWbJ8ohkA"
    "http://www.youtube.com/embed/QqUzcthkvcc"
    #f #f #f #f #f #f))

(define examples
  ;; Body of the examples; each entry is a list of body elements
  '(((p "One of the most common uses for grids is movement. Maybe you have a
        tactical game, or a board game or you just want the old-school feel of
        tile based games.  In this example we convert the hero's world
        coordinates to grid coordinates and then move it in grid space before
        converting the result back to world space. As an extra touch we can
        limit the hero to only stay within the bounds of the grid size. We
        need this because grids are infinitely large, so the sphere could
        wander off into infinity.")
     (p "This example demonstrates one of the simplest and most common uses for
        Grid Framework: converting between coordinate systems. We take the
        object's current position, convert is to grid space, add a direction to
        it, convert the result back to world space and use that as the
        destination of our movement function.")
     (div (@ (class "highlight"))
       (pre "var goal = grid.WorldToGrid(transform.position)
goal += Vector3.right;
transform.position = grid.GridToWorld(goal);"))
     (p "This alone is not that interesting, so let's limit the player to the
         visible region of the grid. Every grid is infinitely large, but the "
        (em "renderer")
        " has a range we can use as limits before converting back
        to world coordinates:")
     (div (@ (class "highlight"))
       (pre "if (goal.x < _renderer.From.x || goal.x > _renderer.To.x)
    return;
if (goal.y < _renderer.From.y || goal.y > _renderer.To.y)
    return;"))
     (p "As a final touch, let's use Grid Framework to store the map of the
        game.  It will know which tiles are OK to walk on and which ones are
        obstacles.  We will use a 2D array to keep track of the game; each
        entry's row and column corresponds to the tile's X- and Y coordinates
        in the grid.")
     (div (@ (class "highlight"))
       (pre "// After checking for range, before converting to world coordinates
if (!FreeTile(_goal)) {
    return;
}

// Building the matrix
var rows    = Mathf.FloorToInt(_renderer.To.x);
var columns = Mathf.FloorToInt(_renderer.To.y);

_tiles = new bool[rows, columns];

// Checking a tile (grid coordinates)
var r = Mathf.FloorToInt(tile.x);
var c = Mathf.FloorToInt(tile.y);
return _tiles[r, c];")))

    ((p "Here we learn how write a simple puzzle game where the goal is to turn
        all the lights off and every time you click a light that light and the
        four adjacent ones flip their state. No light knows anything about its
        surrounding lights, making this game very flexible, you can have all
        sorts of crazy shapes and holes in it.")
     (p "The core of this example is comparing the grid coordinates of the
        tiles to the one tile that was clicked to decide whether to switch
        colour. The logic is nicely encapsulated in a custom extension method,
        making it appear as if has always been part of Grid Framework.")
     (div (@ (class "highlight"))
       (pre "if(theGrid.IsAdjacent(transform.position, switchPosition)){
    //flip the state of this switch
    isOn = !isOn;}"))
     (p "This extension method is not part of Grid Framework's API, but we can
        use it as if it were."))

    ((p "In this example we create a bubble puzzle field from an array by
        placing objects on the grid according to the position inside the array.
        This approach has several advantages; most obviously it is faster and
        easier to design levels in data than in an editor, you can add new
        levels very easily, parse them from files, add a level editor, or allow
        players to add their own levels. Instead of having a separate scene for
        each level we only need one scene, we can build new levels without
        having to worry about carrying the background or music from scene to
        scene, allowing for seamless transition.")
     (p "The core of this example is the position of a entries in the array,
        i.e.  the row and column.  We use these array coordinates as grid
        coordinates and convert them to world coordinates.")
     (div (@ (class "highlight"))
       (pre "Vector3 targetPosition = levelGrid.GridToWorld(new Vector3(column, row, 0));")))

    ((p "If you want to allow the user to place object only on the grid, then
        this example is for you.  Snapping is a two-step process: first we move
        the object to where the cursor is pointing, then we correct the
        position.")
     (div (@ (class "highlight"))
       (pre "transform.position = cursorWorldPoint;
grid.AlignTransform(transform);")))

    ((p "Grids are infinity large when it come to calculations, but rendering
        an infinite amount of lines is impossible.  We will use a trick instead
        where we dynamically adjust the rendering range of the grid according
        to the camera.  The result is a seamless illusion that only renders the
        bare minimum and only updates when it has to.") 
     (div (@ (class "highlight"))
       (pre "for (int i = 0; i < 3; i++) {
    rangeShift[i] += transform.position[i] - lastPosition[i];
}

renderer.From += rangeShift;
renderer.To   += rangeShift;")))

    ((p "We generate a mesh as a SimCity-like terrain from data. Clicking a
        vertex raises or lowers it. Everything is accomplished be converting
        from grid coordinates to world coordinates."))

    ((p "A rotary dial as it would have been found on older phones. When the
        player clicks a sector of this polar grid the grid coordinates are used
        to determine which number was selected and use it to control the
        animation and print that number on the console."))

    ((p "Sometimes Unit's physics engine is too good for its own good and we
        need something simpler instead. In a sliding puzzle it is common for
        blocks to be touching each other with no space between, yet the player
        will expect there to be no friction.  In this example we use Grid
        Framework to construct a matrix of cells and track for each cell
        whether it's free or occupied. Then we restrict movement of the blocks
        based on that information."))

    ((p "Another example of tile-base movement. The snake is made of several
        segments, linked together using a list. Only the head moves, the other
        segments follow their parent."))

    ((p "Having some fun with Vectrosity and laser lines. The grids can move
        around or even change their properties at runtime."))))

(define content
  `((p "To help you get started Grid Framework comes with several examples
      showing you how to implement from scratch features commonly found in
      games, such as moving along a grid, using the grid for game logic like in
      a puzzle game, assembling a level or even extending Grid Framework with
      your own methods without touching the source code of Grid Framework
      itself.")
    (p "The source code has comments explaining the idea behind almost every line
       of code. I also have tutorial videos where I build those examples from
       scratch and explain the idea behind the code, for those of you who prefer
       learning by doing rather than having the source code served to them in
       one go.")
    (p "Click a title to get to a playable build, or watch a video of me coding
       the example live. These videos were recorded at different points in Grid
       Frameworks development and the interface and usability may appear more
       crude than it currently is. If the example doesn't load right away
       please be patient.")
    (hr)
    ,@(map example->sxml example-titles example-urls example-videos examples)))

`((content  . ,content)
  (title    . "Examples - Grid Framework")
  (sub-site . grid-framework)
  (css      . ("/css/grid-framework.css")))