#!/usr/bin/guile
!#

(define metadata
  '((title .  "HiPhish's Workshop - About")))

(define content
  '((h3 "About the author")
    (p
      "Hi, I'm HiPhish and this is my website. I'm a mathematician and a
      programmer and my motto is <em>I want to to exist, so I'll make it</em>.
      The goal is rock-solid software that is reliable and fit for productive
      use, because I wouldn't want to use anything else myself.")
    (p
      "I chose the "
      (em "Workshop")
      " motto because I consider programming to be a craft. This site is where
      I exhibit my work, present my services, and if you follow the links to my
      repositories you can see the details or how it is made. Programming is a
      new form of craftsmanship and the computer is our workbench.")
    (hr)
    (h3 "About this website")
    (p
      "The Workshop would not be in its current form if it were not for these
       great tools written by other people.")
    (dl
      (dt
        (a (@ (href "http://www.gnu.org/software/guile/"))
          "GNU Guile"))
      (dd
        (p
          "An implementation of the Scheme programming language and the
          canonical scripting language of the GNU project. The entire website
          is written as a Scheme program, making use of the duality between
          code and data in Lisp. Guile was chosen because it comes with all the
          libraries I needed right out of the box. When the program is run it
          generates all the static content of the website.")
        (p "Using a real programming language over a pre-made static site
           generator allows me to have full control over the generation
           process. Templates are just regular Scheme procedures and new
           features can be added directly at the source code level."))
      (dt
        (a (@ (href "http://getbootstrap.com"))
          "Bootstrap")
        " and "
        (a (@ (href "http://bootswatch.com"))
          "Bootswatch")
        )
      (dd
        (p
          "Bootstrap is a CSS framework that provides a collection of useful
          classes for responsive and accessible web design. It provides a
          grid system for layout that allows one to easily create layout
          that looks good on any screen size.")
        (p
          "Bootswatch is a collection of customized Bootstrap style sheets
          intended as complete drop-in themes."))
      (dt
        (a (@ (href "http://www.no-margin-for-errors.com/projects/prettyPhoto-jquery-lightbox-clone/"))
          "prettyPhoto"))
      (dd
        (p
          "A JavaScript gallery plugin that provides nice looking overlays
          for images. You can also navigate between images without leaving
          the gallery."))
      (dt
        (a (@ (href "http://philipwalton.github.io/solved-by-flexbox/"))
          "Solved by Flexbox"))
      (dd
        (p
          "Flexbox is a new CSS feature that allows you to lay out content
          in a flexible way. Instead of hardcoding values position, size or
          order of elements can be given relative to each over other or the
          enclosing container.  Flexbox makes many previously hard and hacky
          problems trivial to solve. "
          (em "Solved by Flexbox")
          " features a collection of solutions to common problems.  In my case
          I used it for the sticky footer and the blog layout.")))
    (p
      "All content is written in Neovim, packages are managed in Node.js and
      Bower. The website content is version-controlled using Git.")
    (hr)
    (h3 "LibreJS - Free JavaScript")
    (p
      "The Workshop is build from free (libre) software that respects the
      user's freedom. The same also applies to the JavaScript employed on this
      site. I have made sure that the site complies with the LibreJS
      specifications. You can find a list of scripts employed under "
      (a (@ (href "javascript"))
        "about/javascript/")
      ".")
    (hr)
    (h3 "Source code")
    (p
      "The Scheme source code for the workshop is available in a "
      (a (@ (href "https://github.com/HiPhish/workshop"))
        "public repo")
      ". If anything on the website is not working, please file an issue.")
    (h3 (@ (id "content-license"))
       "License")
    (p
      "Unless otherwise noted the content on this site is licensed under the
      Creative Commons "
      (a (@ (href "http://creativecommons.org/licenses/by-sa/4.0/"))
        "Attribution-ShareAlike 4.0 International")
      " license (CC BY-SA 4.0). In short, the license allows you to use content
      even for commercial use, as long as you make sure to to give proper
      credit.  Please read the license for detailed information.")))

(acons 'content content metadata)
