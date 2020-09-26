(use-modules (component static-page))

(static-page ((title "Vim - HiPhish's Workshop"))
  (h1 "Vim and Neovim")
  (p "I use "
     (a (@ (href "https://neovim.io/")) "Neovim")
     " as my text editor and this page will hopefully serve as a hub for
     various Vim-related topics. In the meantime you can read about the "
     (a (@ (href "plugins/")) "plugins")
     " I have written."))
