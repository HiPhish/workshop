#!/usr/bin/guile
!#

(define content
  '((h1 "Vim and Neovim")
    (p "I use "
       (a (@ (href "https://neovim.io/")) "Neovim")
       " as my text editor and this page will hopefully serve as a hub for
       various Vim-related topics. In the meantime you can read about the "
       (a (@ (href "plugins/")) "plugins")
       " I have written.")))

`((title . "Vim - HiPhish's Workshop")
  (content . ,content))
