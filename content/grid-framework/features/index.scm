#!/usr/bin/guile
!#

(define metadata
  '((title    . "Features - Grid Framework") 
    (sub-site . grid-framework)
    (css      . ("features.css"))))

(define features
  ;; A list of features. Each entry is a list of two feature-lists.
  '(("How it works"
     (p "The heart of Grid Framework are the new grid classes. They are
        components, so you add them to any of your Game Objects you wish.  You
        can add grids either using the editor or programmatically at runtime
        and modify its properties.")
     (pre
       (code
         "GameObject go;\n"
         "RectGrid grid = go.AddComponent<RectGrid>();\n"
         "// Add a renderer for display\n"
         "go.AddComponent<Parallelepiped>()\n"
         "\n"
         "// Set up the grid for 2:1 dimetric graphics\n"
         "grid.spacing  = new Vector3(2, 1, 1);\n"
         "grid.shearing = new Vector6(-1/2, 0, 2, 0, 0, 0);\n"
         "// Vector6 is a custom type, not part of the Unity API"))
     (p "All custom types reside in custom namespaces to protect from name
        collisions with your own types or possible future types from Unity. The
        namespace import was omitted for brevity.")
     (p "With the grid set up in your scene you are ready to go. You now have
        access to a vast and rich API you can use for your own application."))
    ("Calculations"
     (p "Grid Framework can convert from world coordinates to grid coordinates
        and vice- versa with just one line of code. You can let it find the
        nearest vertex, face or box, scale objects or snap them in place
        without needing to write any formulae, it's all wrapped up for
        you.")
     (p "This allows you to write your game logic thinking entirely in grid
         coordinates while the game plays out in world coordinates.  Then just
         let Grid Framework convert the result back into world space and
         you're ready to go.")
     (p "Let's say we wanted to move a unit from one point in the grid to
         another. If we know the grid coordinates we can compute the world
         coordinates and pass them to your movement function:")
     (pre
        (code
          "Vector3 origin      = grid.gridToWorld(originInGrid    );\n"
          "Vector3 destination = grid.gridToWorld(desinationInGrid);\n"
          "MoveUnit(from: origin, to: destination);"))
     (p "A common task is snapping things to a grid, for example when the
        player is trying to place building in a strategy game. This is where
        the "
        (code "AlignTransform")
        " extension method comes into play:")
     (pre
       (code
         "Transform t;\n"
         "// Move the object the usual way with no snapping first\n"
         "// And then correct its position by snapping\n"
         "grid.AlignTransform(t);"))
     (p "Usually the "
        (code "AlignTransform")
        " method is smart enough to do what you want, but if you want more
         control you can use the lower-level methods to build your own
         rules."))
    ("Infinite Size And Fully 3D"
     (p "The size of a grid is irrelevant, what really defines a grid is its
        origin, its type and a few parameters. Using this information we can
        perform any calculation at any point, without dependence on how far
        from the origin we are.")
     (p "In fact, the distance doesn't even impact our performance, all
        calculations always run at the same speed. Of course Grid Framework's
        infinity is limited to what Unity is capable of and there is no true
        infinity on computers, but Grid Framework can get as close to it as
        possible in Unity. Best of all, grids are in 3D and move and, being
        components, rotate with the object they are attached to; if you need a
        grid's rotation or position just get the information from the "
        (code "Transform")
        " component, like any other object in Unity.")
     (pre
       (code
         "// This works as you would expect\n"
         "Quaternion gridRotation = grid.transform.rotation;")))
    ("Small memory footprint"
     (p "Grid Framework was designed to keep it simple, to just be there when
        you need it but never intrude with the workflow. All calculation
        methods run in constant time and the classes just store a handful of
        float values.")
     (p "This keeps the performance impact to a minimum. It makes Grid
        Framework suitable for desktop devices as well as mobile phones and
        tablets where memory is more constrained than on desktop computers."))
    ("Rendering & Drawing"
     (p "You can both draw your grids in the editor using gizmos and render
         them at runtime. You can turn individual axes on or off, set the
         colour for each axis individually, change the width of the lines and
         even use your own shaders if the default shader doesn't suit your
         needs.")
     (p "Redering is done using "
        (code "Renderer")
        " components and Unity's low-level rendering capabilities, so it is
        blazing fast even on mobile devices. Keep in mind though, that while
        the rendering is cheap, getting points for large and very dense grids
        might not be. If your grids are exceptionally large you will be glad
        to know that Grid Framework can compute points for use with the
        popular Vectrosity add-on.")
     (pre
       (code
         "// Set the rendering range and colour\n"
         "renderer.From   = new Vector3( 0,  0, 0);\n"
         "renderer.To     = new Vector3(10, 10, 5);\n"
         "renderer.ColorX = Color.black;")))
     ("Vectrosity Support"
     (p "Vectrosity is a popular 3rd party vector line drawing solution for
         Unity. Instead of rendering lines point by point, Vectrosity can
         construct a mesh and then render the mesh in one go, making it an
         ideal solution for complex shapes with many points, such as very
         dense grids.")
     (p "Using Vectrosity on its own would require you to compute all end
        points yourself and then order them in the proper way so they appear
        in the right order; Grid Framework can do the job for you by just
        calling the built in method. For more information on Vectrosity please
        visit "
        (a (@ (href "http://starscenesoftware.com/vectrosity.html"))
          "Vectrosity's web site")
        ". Vectrosity and Grid Framework are entirely unrelated products and I
        am in no way affiliated with the author of Vectrosity.")
     (pre
       (code
         "// Grid Framework gets the points and then Vectrosity takes over\n"
         "var points = grid.GetVectrosityPoints();\n"
         "gridLine = new Vectrosity.VectorLine(\"My lines\", points, lineColors, lineMaterial, lineWidth);")))
    ("Playmaker Support"
     (p "Grid Framwork also supports the popular "
        (a (@ (href "http://hutonggames.com/"))
           "Playmaker") 
        " add-on for visual scripting.")
     (p "The entire API, except for a few instances, is available as Playmaker
        actions. You can use these action as building blocks in your state
        machines to get and set properties and call methods.  Due to technical
        reasons any properties that rely on types not built into Unity cannot
        be set or gotten; they will be added if Playmaker becomes capable of
        handling custom types."))
     ("Fits Seamlessly Into Unity"
     (p "There is no new interface to learn or new editor panel to add to the
        project (unless you want to use the align panel of course), instead it
        fits nicely into Unity as if it had always been a part of it.")
     (p "The grid classes have their own custom inspector and you can create
        grids from scratch, add a grid component to any of your Game Objects
        or browse the documentation right from you menu bar, just like any
        other component in Unity."))
    ("Full Documentation"
     (p "Like Unity itself, Grid Frameworks comes with a user manual that
        explains you the ideas and concepts of Grid Framework, the coordinate
        systems used and the design principles. The scripting reference has
        all classes with their member variables and methods covered.
        Hyperlinks to entries in the documentation as well as links to Unity's
        own scripting reference let you find anything conveniently.")
     )
    ("Free Updates"
     (p "As Grid Framework improves update will be released adding new
         features. Once you buy a copy of Grid Framework you will be entitled
         to all future updates for free, even if the price goes up. This is my
         way way of thanking everyone who supports me in the early stages :)")
     )))

(define (feature->sxml title first . rest)
  `(div
     (h2 ,title)
     ,first
     ,@(if (not (null? rest))
         `((p (@ (class "expand")  ; Will be unhidden by Javascript
                 (hidden "hidden"))
             (a "Click to expand"))
           (div (@ (class "expandable"))
             ,@rest))
         '())))

(define content
  `((div (@ (id "features"))
      ,@(map (λ (feature) (apply feature->sxml feature)) features))
    (script (@ (src "features.js"))
      "")))

(acons 'content content metadata)
