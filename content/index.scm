#!/usr/bin/guile
!#

(use-modules
  ((ice-9 match) #:select (match)))

(define metadata
  '((title . "HiPhish's Workshop - Home")
    (css   . ("index.css"))))

(define (product->sxml product)
  (match product
    ((title (url image alt description))
     `(article
        (h3 ,title)
        ,@description
        (img (@ (src ,(string-append "images/" image))
                (alt ,alt)))
        (p (@ (class "link"))
          (a (@ (href ,url))
            "Learn more"))))))

;; Association list, using the title of the product as the key, and a list of
;; URL, image, alt-image and description as the value.
(define products
  '(("Grid Framework"
      ("/grid-framework/"
       "grid-framework.png"
       "Grid Framework logo"
       ((p "Grid-based game logic for Unity3D that is both simple and powerful.
         Custom classes wrap up all the math in a simple, flexible and powerful
         API for use as it fits your project. Includes also editor extensions
         and examples."))))
    ("info.vim"
      ("https://gitlab.com/HiPhish/info.vim"
       "info.vim.png"
       "info.vim screenshot"
       ((p "A fully-featured reader and browser for info documents from inside
         Vim.  Supports all the same navigation as standalone- and Emacs info,
         but with all the comfort of Vim."))))
    ("Repl.nvim"
      ("https://gitlab.com/HiPhish/repl.nvim"
       "repl.nvim.png"
       "REPL.nvim image"
       ((p "Open and manage REPL instances right from inside Nvim, and send text
         to the REPL buffer. New types can be defined and existing defaults can
         be altered.  An API provides functionality for 3rd party plugins as
         well."))))
    ("NTFS-Clone"
      ("https://gitlab.com/HiPhish/ntfs-clone"
       "analogue-data-disc-117729.jpg"
       "NTFS-clone logo"
       ((p "Create perfect 1:1 copies of NTFS hard drives. The resulting hard
         drive can be inserted right back into a PC and be booted from without
         having to run any additional steps."))))
    ("IPS-Tools"
      ("https://gitlab.com/HiPhish/IPS-Tools"
       "ips.svg"
       "IPS-Tools logo"
       ((p "Command-line tools and C library for working with binary patches in
         the IPS format, supports the common \"truncation\" extension. Users can
         apply and generate patches, inspect patch files, and use the library in
         their own applications."))))
    ("Newton's method in C"
      ("https://github.com/HiPhish/Newton-method"
       "newton.png"
       "Newton's method logo"
       ((p "One of my earlier projects written as an exercise for myself.  It
         implements Newton's method of finding the root of a function in C using
         only the standard library. The program acts as a compiler and virtual
         machine for the function string entered and can interpret any legal
         function syntax."))))
    (((code "roll") " - Roll dice on the command line")
      ("https://gitlab.com/HiPhish/roll"
       "black-black-and-white-cubes-37534.jpg"
       "'roll' logo"
       ((p "Generate random numbers from virtual dice. Useful for generating
         diceware passphrases and whatever else you might need random integer
         numbers for."))))
    ("Game source documenation"
      ("https://github.com/HiPhish/Game-Source-Documentation"
       "game-docs.png"
       "Game source documentation screenshot"
       ((p "We all love classic video games, and we also love when they get some
         modern polish. If it just wasn't for all the encrusted ancient code.
         This ongoing project aims to document the source codes of old games
         well enough that a port could be built from the specifications
         alone."))))
    ("XeenTools"
      ("https://github.com/HiPhish/XeenTools"
       "xeen.png"
       "Image extracted from the game"
       ((p "An ongoing effort to write a library that can read assets from the "
         (em "Might & Magic IV and V")
         " games. The idea is to write a library that can be used as a basis for
         a modern source port."))))))

(define content
  `((div (@ (class "billboard"))
      (h1 "Welcome to the workshop")
      (p "I make things, usually with software, and occasionally I write, usually
          about software as well. The workshop is home to my projects, both
          commercial and free, and I invite you to browse my projects and my
          open source codes.")
      (p "I also contribute to free libre open source projects when there is an
          opportunity, so check out those projects as well."))
    (article (@ (role "main"))
      (section (@ (id "products"))
        (h2 "Products made at the workshop")
        ,@(map product->sxml products)))))

(acons 'content content metadata)
