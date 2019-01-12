(define metadata '((title    . "Grid Framework version 2.0.0 released")
                   (category . "release")))

(define content
  '((p
      "After almost half  a year in  the making  Grid Framework  version 2.0
      has been released on the Unity "
      (a (@ (href "https://www.assetstore.unity3d.com/en/#!/content/62498"))
        "Asset Store")
      ". This is the first major
      release since the initial launch  and will make Grid Framework  easier to
      use,  more powerful and more flexible with no extra performance overhead.
      Being a major version update this breaks compatibility  with the version
      1.x releases,  but an upgrade guide is included in  the user manual.  If
      you  still cannot  upgrade to  2.0 you can still keep using 1.x, but the
      old releases will not be getting any new features anymore.")
    (p
      "Version 1.x  has been  deprecated on  the Asset Store,  which means  you
      can no longer purchase it,  but you  can still  access it if  you
      purchased it  in the past. All existing customers  can get a free upgrade
      to version 2.0,  it really is that much better.")
    (h2 "What is new")
    (p
      "The changes are too many to list as a simple changelog,  almost all of
      the code has been refactored. I will give you the highlights instead.")
    (dl
      (dt "Separate grids and rederers")
      (dd
        (p
          "In the past a grid has had many jobs: be a grid, convert
          coordinates, show the grid and possibly even more. This lead to very
          few but very large classes with a large public API. It was hard for
          users to find what they were looking for and hard from me to
          maintain.")
        (p
          "The tasks have now been split up: Grids are just grids and convert
          coordinates while designated renderer classes are responsible for
          computing how to display the grids. There can be more than one
          renderer type for every grid, such as the different shapes of hex
          grids. This leads to more classes, but every class is much smaller
          than the one big class it originates from."))
      (dt "A leaner and cleaner API")
      (dd
        (p
          "Some features had  been added to  Grid Framework because  they
          seemed handy, but while  re-evaluating  the framework  I found  that
          a  lot  of  them were redundant of leftovers from previous  releases
          that had been kept in for the sake of compatibility. Take for
          examples " (code "size") " and " (code "renderFrom") "/"
          (code "renderTo") ", the " (code "size")
          " is  really just a  special case  of setting " (code "renderFrom")
          " and " (code "renderTo") " to the same value with opposite sign."))
        (p
          "This is just confusing and adds no real value for the user. If
          something can be  fully  replicated with  one or  two  lines  of code
          and no  overhead it shouldn't be part of the framework. A major
          release is a good opportunity to throw out the old stuff.")
      (dt "Official extension methods")
      (dd
        (p
          "Throwing redundant  API out  is easy,  but what  about API that  is
          actually useful but does  not really fit  the nature of  the class?
          Take for example "
          (code "AlignTransform")
          ": aligning objects is very useful and not too trivial,  but it does
          not really  belong in  the grid class.  The C#  language  offers a
          feature for this: extension methods.")
        (p
          "Extension methods need to be explicitly imported,  but they are used
          just as if they were methods of  the class they extend.  Grid
          Framework comes with a number of useful standard extension methods
          grouped by task. You will now be able to find what you are looking
          for much faster."))
      (dt "A flexible rendering pipeline")
      (dd
        (p
          "In version 1.x the  rendering process has been  mostly \"magic\"
          where you set the values of the  grid and then lines appear.  In
          version 2.0 the rendering now passes through a number of stages  and
          you can intercept any of them and take full control over the process
          from there.")
        (p
          "Of course if  you don't need  that you can  leave things as  they
          are and it will just work as it did before."))
      (dt "Events fired by grids")
      (dd
        (p
          "We are now making use  of the C# ability to use  messages on certain
          events, i.e. when the  properties of a grid change.  This allows you
          to only do work when something has happened instead of having to poll
          the grid constantly.")
        (p
          "This feature is used by renderers to only update the lines when the
          grid has actually changed."))
      (dt "Namespaces over prefixes")
      (dd
        (p
          "Older  versions  of Unity  had  trouble with "
          (code "MonoBehaviour")
          " subclasses in custom namespaces, forcing me to prefix every class
          with "
          (code "GF")
          ". Because Unity versions less than 5 are no longer supported the
          prefix has been dropped in favour of finely grained namespaces."))
      (dt "Write your own")
      (dd
        (p
          "Splitting up  large classes  has a  very pleasant  side effect:  you
          can now write  your  own grids,  renderers  and  extension methods.
          This  makes  it possible the extend the framework  to your particular
          needs just the way you need it.")
        (p
          "For version 2.0 the protected  properties of classes are documented
          as well, you now  have exactly  the same  power over the  framework
          as  I do  without having to modify the original."))
      (dt "Unified directory")
      (dd
        (p
          "Last but not least,  all of Grid Framework is now contained in one
          directory in your project. T here is nothing to clutter up your
          project anymore thanks to improvements to the engine in Unity 5 now
          that I was able to drop support for Unity 4.")
        (p
          "In  particular  this means  that the  *WebPlayerTemplates*
          directory is  no longer  being  abused  to  stop  Unity  from
          compiling  JavaScript  files as UnityScript."))
      )
    (h2 "File size comparison")
    (p
      "When I originally announced the major version update I was looking at
      the sizes of the classes in terms of lines of code. Here is the old
      chart:")
    (table (@ (class "table-striped table-hover table")
              (border "1"))
      (thead (@ (valign "bottom"))
        (tr (th (@ (class "head")) "Class")
            (th (@ (class "head")) "Code")
            (th (@ (class "head")) "Comment")
            (th (@ (class "head")) "Blank")
            (th (@ (class "head")) "Total")))
      (tbody (@ (valign "top"))
        (tr (td "GFGrid"      ) (td  "520") (td  "512") (td "104") (td "1136"))
        (tr (td "GFRectGrid"  ) (td  "202") (td  "167") (td  "51") (td  "420"))
        (tr (td "GFSphereGrid") (td  "356") (td  "615") (td  "92") (td "1063"))
        (tr (td "GFHexGrid"   ) (td "1257") (td "1102") (td "241") (td "2600"))
        (tr (td "GFPolarGrid" ) (td  "395") (td  "366") (td  "74") (td  "835"))))
    (p 
      "Even if we ignore the comments these classes are huge,  especially "
      (code "GFHexGrid")
      ". How do the new grids fare in comparison?")
    (table (@ (class "table-striped table-hover table")
              (border "1"))
      (thead
        (th "Class") (th "Code") (th "Comment") (th "Blank") (th "Total") (th "Code reduction"))
      (tbody
        (tr (td "Grid"      ) (td  "37") (td  "69") (td   "5") (td  "111") (td "93%"))
        (tr (td "RectGrid"  ) (td "143") (td "174") (td  "35") (td  "352") (td "29%"))
        (tr (td "SphereGrid") (td "264") (td "440") (td  "64") (td  "768") (td "26%"))
        (tr (td "HexGrid"   ) (td "443") (td "944") (td "108") (td "1545") (td "65%"))
        (tr (td "PolarGrid" ) (td "179") (td "242") (td  "42") (td  "464") (td "55%"))))
    (p
      "The biggest reduction is in the abstract "
      (code "Grid")
      " class which is the basis of all grids.  The massive reduction comes from
      factoring out the rendering task into the new flexible  pipeline and the
      removal  of a lot of redundant API.  At this point "
      (code "Grid")
      " is just a skeleton of private and protected members.")
    (p
      (code "HexGrid")
      " has had more  than half of its  code removed,  the largest part of it
      was the different ways  to render a hex grid which  are now individual
      renderer classes.  The class is still quite large though, because of the
      many coordinate systems it has. However, factoring out the coordinate
      system conversions out of grids would remove all functionality out of
      them.")
    (p
      "The other grids  have had less  code reduction because  they were already
      quite small,  the  large  API  was  mostly  just  inherited  from  the
      parent  class. "
      (code "PolarGrid")
      " has had  a nice reduction  because a lot of conversions have  been made
      into extension methods.")
    (p
      "If you are wondering  why I have more lines  of comments than actual
      code,  the reason is  that the  API documentation  is written  inside the
      source files as special comments.  On top of that the proper  way of
      writing API comments is to use XML  syntax.  Doxygen can use  other styles
      of comments,  but last  time I checked only XML comments would show up in
      MonoDevelop during auto completion.")
    (h2 "Where to go from here")
    (p
      "As far as features are  concerned I think Grid Framework is very
      complete.  I'm still open to suggestions,  but I don't  have any concrete
      plans for now.  The next step is to  step up my presentation,  the
      introduction video is still from the initial release and the screenshots
      are very crude to put it nicely. I also need  a  better  looking  logo,
      made  with  vectors  preferably.  I have  been experimenting with
      different illustration software,  but none had to ability to generate a
      nice regular grid,  I need some programmatic solution. "
      (a (@ (href "https://racket-lang.org")) "Racket")
      " can generate vector graphics from code, so I'll try to look into that.")
    (p
      "I would  also  like  to replace  the "
      (a (@ (href "http://www.doxygen.nl")) "Doxygen")
      "-generated  documentation  with  a "
      (a (@ (href "http://www.sphinx-doc.org/en/stable/")) "Sphinx")
      " -based one.  Doxygen is great for extracting documentation comments from
      source files,  but the HTML  output is very rigid.  Sphinx lets  me use "
      (a (@ (href "http://jinja.pocoo.org"))"Jinja")
      " templates,  which is something I am already using for this website.
      This would require a C#  domain for Sphinx,  something I have been working
      on on the side, but it is nowhere near useful yet.")
    (p
      "Another thing I would  like to do is port Grid Framework  to engines
      other than Unity. With version 2.0 the codebase is in a state that is
      clean enough that it could be re-written  in another language.  I'm not
      announcing anything yet,  so don't hold your breath too long :)")
    (p
      "If you have made  it this far thank  you for reading and  I hope you will
      enjoy the improvements.  If you like the  product please  leave a review,
      and if you don't like it tell  me so I can make it better.  Don't forget
      that you can have your games showcased on my website as well,  I really
      want to see what you make with Grid Framework.")))

(acons 'content content metadata)
