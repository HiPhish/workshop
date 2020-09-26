(use-modules (component static-page))

(static-page ((title    "Grid Framework - HiPhish's Workshop")
              (sub-site 'grid-framework)
              (css      '("grid-framework.css")))
  (div (@ (class "billboard"))
    (div
      (h1 "Grid Framework")
      (p
        "Code grid-based game logic in no time with Grid Framework, a simple
        and versatile scripting add-on for the Unity3D game
        engine."))
    (img (@ (src   "images/logo.png")
            (alt   "Grid Framework logo"))))
  (div (@ (class "highlights"))
    (div 
      (h3 "Flexible")
      (p
        "You don't write your project to fit Grid Framework, Grid
         Framework fits your project. Use the scripting API in any way you
         want, for any purpose you want. See the examples to get some ideas."))
    (div 
      (h3 "Ready to go")
      (p
        "All you have to do is add a grid component to one of your objects
         and you can start scripting. The included user manual, API
         reference and included examples allow you to be productive in no
         time."))
    (div 
      (h3 "Lightweight")
      (p
        "Grids store only the absolute minimum of information necessary:
         their spacing, their range and information on how to display. This
         allows you to have infinitely large grids with minimal memory
         footprint.")))
  (h2 "What is Grid Framework?")
  (p
    "Grid Framework is a powerful and easy to use solution for all your grid
     based needs. By providing you with new classes all you need to do is
     apply the grid component of your choice onto a "
    (code "GameObject")
    ", set the values to your liking and start writing your game logic
    without worrying about the underlying math. No matter whether you are
    making a board game, a strategy game, a puzzle game, an arcade-style game
    or just any other type of game that needs clockwork-like precision, Grid
    Framework will help you in setting up your game and writing your game
    logic in an intuitive way.")
  (p
    "The simplest way to describe Grid Framework would be to call it a
     library. It provides you with new classes and new components complete
     with custom inspectors, ready to use. It also serves as an editor
     extension by providing you with an align panel that lets you auto-snap
     objects right in the editor. You can set the properties of the new grid
     components in the editor and use them in scripting, same as any other
     component of Unity.")
  (hr)
  (h2 "Why Grid Framework?")
  (p
    "Grid Framework was carefully designed with flexibility in mind. No two
     games are the same, and even if they might appear similar on the outside,
     their inner workings could be very different. I wanted to write a
     solutions that doesn't lock you into a specific workflow, instead it
     gives you the parts needed and you put them in place the way that suits
     your game best. All Grid Framework does is wrap up the mathematical
     formulae into simple methods to call, allowing you to focus on the actual
     game instead.")
  (hr)
  (h2 "What Grid Framework is not")
  (p
    "It is important to understand that Grid Framework is not a kit that
     takes away all the coding, you still need to code your game logic.
     However, unlike a kit that locks you into a specific workflow and only
     allows you to do what its developer intended, Grid Framework has no
     limited use and seamlessly fits into your own workflow. Whether you
     want to rewrite your existing logic or start from scratch does not
     matter, it fits around "
     (em "your")
     " project.")
  (hr)
  (h2 "What Is Included?")
  (p
    "To help you out there are several examples included to demonstrate how
     to perform common tasks, such as moving the player on a grid, snapping
     objects during runtime or assembling levels from plain text files. The
     code is commented thoroughly and every example comes with a document
     outlining the ideas and principles employed. You can even try out the "
     (a (@ (href "examples")) "examples")
     " right here in your browser.")
  (p
    "This is a quick overview of the features of Grid Framework, for more
     details please visit the features page.")
  (ul
    (li "Components for rectangular, hexagonal and polar grids")
    (li "Renderer components for said grids")
    (li "Write your own grids or renderers for both existing and custom grids")
    (li "Rendering grids at runtime")
    (li "Editor panel for aligning and scaling objects")
    (li "User manual and scripting reference")
    (li "Many examples with fully commented source code")
    (li "The full source code of Grid Framework, written in C#")
    (li "Support for Vectrosity and PlayMaker Unity addons")))
