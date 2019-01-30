#!/usr/bin/guile
!#

(define metadata
  '((title . "HiPhish's Workshop - Home")
    (css   . ("index.css"))))

(define (product->sxml title img alt url description)
  `(article
     (div
       (h3 ,title)
       ,@description
       (img (@ (class "img-responsive")
               (src ,(string-append "images/" img))
               (alt ,alt)))
       (p (@ (class "link"))
         (a (@ (class "btn btn-default")
               (href  ,url)
               (role  "button"))
           "Learn more")))))

(define product-titles
  '("Grid Framework"
    "info.vim"
    "Repl.nvim"
    "NTFS-Clone"
    "Newton's method in C"
    ((code "roll") " - Roll dice on the command line")
    "Game source documenation"
    "XeenTools"))

(define product-imgs
  '("grid-framework.png" "info.vim.png" "repl.nvim.png"
    "ntfs-clone.png"     "newton.png"   "roll.jpg"
    "game-docs.png"      "xeen.png"))

(define product-alts
  '("Grid Framework logo" "info.vim screenshot"  "REPL.nvim image"
    "NTFS-clone logo"     "Newton's method logo" "'roll' logo"
    "Game source documentation screenshot" "Image extracted from the game"))

(define product-urls
  '("/grid-framework/"
    "https://gitlab.com/HiPhish/info.vim"
    "https://gitlab.com/HiPhish/repl.nvim"
    "https://gitlab.com/HiPhish/ntfs-clone"
    "https://github.com/HiPhish/Newton-method"
    "https://gitlab.com/HiPhish/roll"
    "https://github.com/HiPhish/Game-Source-Documentation"
    "https://github.com/HiPhish/XeenTools"))

(define descriptions
  '(((p "Grid-based game logic for Unity3D that is both simple and powerful.
        Custom classes wrap up all the math in a simple, flexible and powerful
        API for use as it fits your project. Includes also editor extensions
        and examples."))
    ((p "A fully-featured reader and browser for info documents from inside
        Vim.  Supports all the same navigation as standalone- and Emacs info,
        but with all the comfort of Vim."))
    ((p "Open and manage REPL instances right from inside Nvim, and send text
        to the REPL buffer. New types can be defined and existing defaults can
        be altered.  An API provides functionality for 3rd party plugins as
        well."))
    ((p "Create perfect 1:1 copies of NTFS hard drives. The resulting hard
        drive can be inserted right back into a PC and be booted from without
        having to run any additional steps."))
    ((p "One of my earlier projects written as an exercise for myself.  It
        implements Newton's method of finding the root of a function in C using
        only the standard library. The program acts as a compiler and virtual
        machine for the function string entered and can interpret any legal
        function syntax."))
    ((p "Generate random numbers from virtual dice. Useful for generating
        diceware passphrases and whatever else you might need random integer
        numbers for."))
    ((p "We all love classic video games, and we also love when they get some
        modern polish. If it just wasn't for all the encrusted ancient code.
        This ongoing project aims to document the source codes of old games
        well enough that a port could be built from the specifications
        alone."))
    ((p "An ongoing effort to write a library that can read assets from the "
        (em "Might & Magic IV and V")
        " games. The idea is to write a library that can be used as a basis for
        a modern source port.")))
  )

(define content
  `((div
      (h1 "Welcome to the workshop")
      (p "I make things, usually with software, and occasionally I write, usually
          about software as well. The workshop is home to my projects, both
          commercial and free, and I invite you to browse my projects and my
          open source codes.")
      (p "I also contribute to free libre open source projects when there is an
          opportunity, so check out those projects as well."))
    (article (@ (role "main"))
      (section (@ (id "products"))
        (h1 "Products made at the workshop")
        ,@(map product->sxml
               product-titles
               product-imgs
               product-alts
               product-urls
               descriptions)))))

(acons 'content content metadata)
