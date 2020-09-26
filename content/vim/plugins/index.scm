(use-modules (component static-page))

(define-syntax-rule
  (vim-plugins->sxml
    (name url
      (body ...))
    ...)
  "Define a series of Vim plugins, spread over the three lists:
  - plugins-list-name: The names of the plugins
  - urls-list-name: List of the URLs for each plugin
  - description-list-name: List of SXML for the plugin descriptions"
  (let ((names  (list name        ...))
        (urls   (list url         ...))
        (bodies (list '(body ...) ...)))
    (map
      (λ (_name _url _body)
        `((dt (a (@ (href ,_url)) ,_name))
          (dd ,@_body)))
      names urls bodies)))

(define vim-plugins
  (vim-plugins->sxml
    ("Guile.vim" "https://gitlab.com/HiPhish/guile.vim"
      ((p (a (@ (href "http://www.gnu.org/software/guile/")) "GNU Guile")
          " is an implementation of the Scheme programming language and
          the official extension language of the "
          (a (@ (href "http://www.gnu.org/")) "GNU project")
          ". Like all Scheme implementations it adds its own extensions on top of
          Scheme. This plugin automatically detects whether a Scheme file is a
          Guile program and adds syntax highlighting for special Guile forms.")
       (p "The file type of Guile buffers will be "
          (code "scheme.guile")
          ", this way users can keep using their existing Scheme plugins and
          settings while still making use of Guile-exclusive plugins and
          settings.")))
    ("Info.vim" "https://gitlab.com/HiPhish/info.vim"
      ((p "Read document in the Info format from inside Vim. "
          (a (@ (href "http://www.gnu.org/software/texinfo/"))
             "GNU Texinfo")
          " is the official format for writing documentation for "
          (a (@ (href "http://www.gnu.org/")) "GNU")
          " projects
          such as "
          (a (@ (href "http://www.gnu.org/software/bash/"))
             "Bash")
          " or "
          (a (@ (href "http://www.gnu.org/software/make/"))
             "GNU Make")
          ", but it is also used by a number of other projects not part of GNU.")
       (p "Info is the on-line format produced by Texinfo and traditionally it
          was read using either a standalone terminal application or Emacs. With
          Info.vim you get a first-class Vim experience. The plugin provides a
          way of reading documents and an API for building upon it.")))
    ("Jinja.vim" "https://gitlab.com/HiPhish/jinja.vim"
      ((p "Adds better integration for "
          (a (@ (href "http://jinja.pocoo.org/")) "Jinja")
          " templates by augmenting the existing file type with " (code ".jinja")
          "rather than only using " (code "jinja") ". This way you could have for
          for example an HTML- and a TeX file with Jinja snippets and their
          extensions would be " (code "html.jinja") " and " (code "tex.jinja") "
          respectively.")
      (p "This is useful because it allows users to keep their settings and
         plugins for the parent file type. In contrast, the "
         (a (@ (href "https://www.vim.org/scripts/script.php?script_id=1856"))
            "official plugin")
         " sets the file type to " (code "jinja") " or " (code "htmljinja")
         "instead.")))
    ("ncm2-vlime" "https://gitlab.com/HiPhish/ncm2-vlime"
      ((p "A plugin for " (a (@ (href "https://github.com/ncm2/ncm2/")) "NCM2")
          " (a completion manager) which provides asynchronous completion of
          Common Lisp source code. It uses the "
          (a (@ (href "https://github.com/l04m33/vlime/")) "Vlime")
          " plugin to get completion candidates.")))))

(define nvim-plugins
  (vim-plugins->sxml
    ("Awk-ward.nvim" "https://gitlab.com/HiPhish/awk-ward.nvim"
      ((p "Turn your Neovim into an interactive Awk development environment. You
          can edit your Awk scripts, edit the input text, and see the result
          displayed immediately in an output buffer.")))
    ("Neovim.rkt" "https://gitlab.com/HiPhish/neovim.rkt"
      ((p "Neovim remote client for "
          (a (@ (href "https://racket-lang.org/")) "Racket")
          ". It allows you to control Neovim from
          Racket and write Neovim plugins in Racket instead of Vimscript.")
       (p " This is both a Racket library, as well as a Neovim plugin, so you
          will need to install it twice, or set it up such that both programs can
          find it. The installation instructions explain it all.")))
    ("REPL.nvim" "https://gitlab.com/HiPhish/repl.nvim"
      ((p "The poor-man's REPL integration, this plugin aims to provide a simple
          universal interface to all possible REPLs. It does so by building on
          top of Neovim's terminal emulator, which has its limitations, but in
          return will work with pretty much any REPL. If you can run it in a
          terminal, you can run it in REPL.nvim as well.")
       (p "A number of common REPLs are supported out of the box, and the exposed
          API allows users or other plugins to define their own REPL setting in a
          few lines of code. Settings for existing REPLs can be overridden
          according to one's own personal preferences.")))
    ("Quicklisp.nvim" "https://gitlab.com/HiPhish/quicklisp.nvim"
      ((p "A Neovim frontend to "
          (a (@ (href "https://www.quicklisp.org/")) "Quicklisp")
          ", the Common Lisp package manager. It allows users to install, remove
          and query Common Lisp packages straight from the Neovim command line.")))))


(define (vim-plugin->sxml name url description)
  `((dt (a (@ (href ,url)) ,name))
    (dd ,@description)))

(static-page ((title "Vim plugins - HiPhish's Workshop")
              (css   '("extra.css")))
  (h1 "Plugins for Vim and Neovim")
  (p "Neovim is my main text editor and over the years I have written a
     number of plugins, both for Vim and Neovim.")
  (h2 "Vim and Neovim")
  (p "The following plugins will work for both Vim and Neovim. If they don't
     that's considered a bug.")
  (dl
    ,@vim-plugins)
  (h2 "Neovim only")
  (p "These plugins only work on Neovim. If anyone wants to submit a patch to
     make them work for Vim as well be my guest.")
  (dl
    ,@nvim-plugins))
