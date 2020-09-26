(use-modules (component static-page))

(define metadata
  '((title    . "FAQ - Grid Framwork")
    (sub-site . grid-framework)))

(define (question->sxml id content)
  `(li
     (a (@ (href ,(string-append "#" id)))
       ,content)))

(define (answer->sxml id question answer)
  `(div (@ (class "faq-item"))
     (h2 (@ (id ,id)
            (class "faq-q"))
       ,question)
     (div (@ (class "faq-a well well-sm"))
       ,@answer)))

(define ids
  '("q-can-i"
    "q-js"
    "q-data"
    "q-patterns"
    "q-renderer-types"
    "q-shape"
    "q-irregular"
    "q-path"
    "q-restrict"))

(define questions
  '("Can I do..."
    "Does Grid Framework work with UnityScript?"
    "Can I store data in the grid?"
    "What grids are supported?"
    "Which renderers are supported?"
    "Can I make irregular grid shapes?"
    "What about irregurar grids like Voronoi grids?"
    "Is pathfinding included, or can I use a pathfinding plugin?"
    "Can I restrict movement or position to the grid?"))

(define answers
  ;; Each answer is a list of SXML expressions to be spliced in
  '(((p "Most questions asked can be answered by understanding what a "
        (em "grid")
        "in Grid Framework is: it is a grid in a mathematical
        sense, which means it is defined by an origin and some basic
        properties (like spacing for rectangular grids) and some visual
        properties. It is not a finite set of points in space.")
     (p "Here is a very rough sketch of what a grid class could look like;
        of course there is more to it in practice, but this gives you a good
        idea.")
     (pre
       (code
         "// Origin and rotation are inherited from the GameObject\n"
         "class RectGrid : Grid {\n"
         "    public Vector3 spacing;\n"
         "    public Vector6 shearing;\n"
         "};"))
     (p "This is what allows grids to be infinitely large in the game and very
        small in memory at the same time. All calculations are performed in
        constant time and cost the same regardless of where in the grid you
        are.  The portion of the grid you see is just a finite-sized slice of
        what is infinitely large."))

    ((p "Yes, UnityScript and C# get compiled to the same bytecode anyway.
        Grids are subclasses of Unity's  (code Component)  class and can be
        manipulated like any other component.")
     (pre
       (code
         "var grid : RectGrid = gameObject.GetComponent.<RectGrid>();\n"
         "grid.spacing = Vector3.one;")))

    ((p "A grid does not store any data in its vertices, cells or anywhere
        because it does not store any vertices to begin with. With that said, we
        can replicate this very easily. This code example creates a
        three-dimenstional array of world-positions of grid vertices. We will
        use a rectangular grid in this example.")
     (pre
       (code
         "int width, height, depth;\n"
         "RectGrid grid;\n"
         "\n"
         "// Change this to whatever type you want\n"
         "Vector3[width, height, depth] vertices = new Vector3[width, height, depth];\n"
         "\n"
         "// Loop over the grid\n"
         "for (var i = 0; i < width; ++i) {\n"
         "    for (var j = 0; j < height, ++j) {\n"
         "        for (var k = 0; k < depth, ++k) {\n"
         "            // store the world coordinates of the grid points\n"
         "            vertices[i, j, k] = grid.GridToWorld(new Vector3(i, j, k));\n"
         "        }\n"
         "    }\n"
         "}"))
     (p "You can then index the array using the grid coordinates of the vertex
        you want. We used a simple "
        (code "Vector3")
        " for our array elements, but we could have used any custom data type
        as well."))

    ((p "At the moment rectangular, spherical, hexagonal and polar
        (cylindrical) grids are supported. Rectangular grids can also have a
        shearing to slant them for an isometric look. Hexagonal and polar grids
        are two-dimensional and can be stacked on top of each other for the
        third dimension."))

    ((p "The renderers depend on the type of grid, with hexagonal grids
        providing multiple renderers.")
     (ul
       (li "Rectangular use the "
           (code "Parallelepiped")
           "renderer which renders the grid as a parallelepiped of adjacent
           parallelepipeds.")
       (li "Spherical grids use the "
           (code "Sphere")
           " renderer to render a potentially partial spherical grid, such as
           the latitude and longitude grid on a globe. It can render spheres
           within spheres.")
       (li "Polar grids use the "
           (code "Cylinder")
           " renderer to display a cylindric shape where the circular portion
           can have a starting and ending angle.")
       (li "Hexagonal grids can rendered as a "
           (code "Cone")
           ", a possibly partial large hexagon made of many smaller hexagons.
           The name derives from the fact that this shape is often used in
           hex-based games to characterize a cone-shaped area of effect.")
       (li "Hexagonal grids can also be rendered as a "
           (code "Rectangle")
           " where every odd column is shifted up- or downwards or clipped.")
       (li "Hexagonal grids can be rendered as a "
           (code "Rhombus")
           " which can be slated up- or downwards.")
       (li "Hexagonal grids can be rendered as a "
           (code "Herringbone" )
           " pattern of edges connecting the central points of the hexes rather
           than drawing the hexes themselves.")))

    ((p "Yes, there are multiple ways. The easiest way is to have multiple
        renderers per grid. Every renderer can then render a different finite
        part of the infinitely large grid.")
     (p "If you wish for more control than that you will have to write your own
        renderer class. Grid Framework provides you with the same protected API
        as was used in writing the official renderers, you have the full power
        at your command.")
     (p "Finally, you can do the rendering yourself or using a rendering plugin
        of your choice for Unity. That way you have full control over the
        shape. You can get the points of the lines to render use the grid's
        (code GridToWorld)  method:")
     (pre
       (code
         "Vector3 from, to;\n"
         "RectGrid grid;\n"
         "\n"
         "Vector3[2] line = new Vector3[] {grid.GridToWorld(from), grid.GridToWorld(to)};"))
     (p "This last approach should not be necessary in most cases, the renderer
         API is powerful enough."))

    ((p "No, a grid (also called a lattice) has to be regular by definition.
         Voronoi \"grids\" are not actually grids, they are graphs and finite in
         size and therefore not suitable for Grid Framework."))

    ((p "At the moment of this writing there is no built-in pathfinding, but
        using Grid Framework with a pathfinding plugin is easy. The plugin will
        need a list of vertices to contrustruct the nav-mesh from, and we can
        get these vertices from the grid by looping over the range we want to
        use:")
     (pre
       (code
         "int width, height, depth;\n"
         "RectGrid grid;\n"
         "\n"
         "Vector3[width, height, depth] vertices = new Vector3[width, height, depth];\n"
         "\n"
         "// Loop over the grid\n"
         "for (var i = 0; i < width; ++i) {\n"
         "    for (var j = 0; j < height, ++j) {\n"
         "        for (var k = 0; k < depth, ++k) {\n"
         "            // store the world coordinates of the grid points\n"
         "            vertices[i, j, k] = grid.GridToWorld(new Vector3(i, j, k));\n"
         "        }\n"
         "    }\n"
         "}"))
     (p "These vertices are in world coordinates and can be then passed on to
       your pathfinding code."))

    ((p "Yes, the easiest way is to align the position to grid coordinates.
         Let's assume your object should fit into the centre of the nearest
         face. Here is the code using a rectangular grid:")
     (pre
       (code
         "Transform myObject; // Object to align\n"
         "RectGrid  myGrid;   // Grid to align to\n"
         "\n"
         "// Use common defaults\n"
         "myGrid.AlignTransform(myObject);\n"
         "// More control\n"
         "myObject.position = myGrid.AlignVector3(myObject.position);\n"
         "// Use grid coordinates\n"
         "Vector3 gridPosition;\n"
         "myObject.position = myGrid.GridToWorld(gridPosition);"))
     (p "As you can see there are multiple possibilities, depending on what
        suits you best. To restrict continuous movement apply the snapping of
        your choice on every frame in your "
        (code "Update()")
        " method."))))

(static-page ((title    "FAQ - Grid Framwork")
              (sub-site 'grid-framework)
              (js       '("https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"))
              (css      '("faq.css")))
  (p "Do you have a question before buying? Check here to see if someone had
       the same question before you. If you don't find what you were looking
       for just ask, the more people ask the same thing, the more likely I am
       to add your question to the list as well.")
  (hr)
  (div (@ (class "faq-toc"))
    (ul
      ,@(map question->sxml ids questions)))
  (,@(map answer->sxml ids questions answers))
  (script (@ (src "faq.js"))
    ""))
