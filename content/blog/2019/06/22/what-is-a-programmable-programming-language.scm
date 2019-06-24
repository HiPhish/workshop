(define content
  '((p "When I was still researching this fabled obscure language called Lisp
       one thing people kept saying about it is that “Lisp is a programmable
       programming language”, but I could never figure out what they meant by
       that. It sounds like a smug buzzword or like a gimmick from an academic
       toy language. Lisp programmers have gotten so used to metaprogramming in
       Lisp that they seem to forget that it is either an entirely alien
       concept to people, or something people have been burned by too often
       (like every C programmer).")
    (p "When I talk about “Lisp” I mean the Lisp language family in general,
       not a particular language from that family. There are differences in how
       macros are written in each one, but the general underlying ideas are the
       same.")
    (h2 "Domain-specific languages")
    (p "The English language has a vocabulary and a grammar. The vocabulary is
       open to extension, we can add to it by assigning a definition to a new
       term.  However, the grammar is fixed, every sentence needs at least a
       subject and a predicate. The phrase “Alice loves Bob” is a correct
       sentence, while “Unfair bullet difference night” is impossible to make
       sense of, even though all the words have meaning. This is so ingrained
       in our mind that I had to pick the words randomly from a dictionary
       because my brain would always try to form a meaningful sentence.")
    (p "However, even though we cannot change the grammar we can define new
       languages with their own grammar that deviates from English grammar.
       Take the expression “"
       (math (@ (xmlns "http://www.w3.org/1998/Math/MathML"))
         (mrow (mn "2") (mo "+") (mn "3") (mo "=") (mn "5")))
       "”; this is not English, yet you can read it easily. It is a
       domain-specific language for specifying mathematical expressions. In
       your mind you can translate it back to English as “The numeric value of
       the sum of the numbers 2 and 3 is the same as the numeric value of the
       number 5”, but the message can get lost in all this fluff. The
       domain-specific language of mathematical notation allows us to express
       facts in a more concise, clear and less ambiguous way.")
    (p "Here is where it gets interesting: how is this new language
       implemented? It was not magically beamed into your brain, you did not
       teach it to yourself through trial and error, it is not something you
       instinctively understand. It was taught to you at a young age in
       English. Someone explained to you in plain English what the symbols mean
       and the rules for how to combine them. (This is not to be take for
       granted, there are also languages one can learn in another way, such as
       body language or the language of facial expressions. Human communication
       is very complex)")
    (p "The key point here is that we can extend a spoken language not only by
       adding to its vocabulary, but also by introducing new constructs which
       do not necessarily follow the grammar of the host language. These
       extensions are implemented in the host language itself.")
    (h2 "Metaprogramming in C")
    (p "What does any of this have to do with programming? The technical
       analogue to the vocabulary of a spoken language is the set of values in
       a program. We can always define new values, new functions, classes,
       operators, and so on. But they always have to follow the “grammar” of
       the programming language. What we are looking for is a way of changing
       these rules themselves.")
    (p "The C preprocessor is a widely know way of metaprogramming. We define
       little snippets which can then be spliced into the source code. Here is
       an example:")
    (pre
      (code (@ (class "language-c"))
        "#define FOO(x, y) (x)\n"
        "int x = FOO(bar(), kill_all_humans());"))
    (p "If " (code "FOO") " was a function it would have evaluated its
       arguments first, which would have killed all humans as a side effect.
       However, the fact that that it is a macro means that the code has been
       rewritten to a harmless call of " (code "bar()") " instead. Macros in C
       are a very naive text-substitution and notoriously hard for getting
       right. They are not written in C, but in another language, and the
       substitution used to be done by a different process than the
       compilation. C++ has added features like templates precisely to avoid
       the preprocessor, but doing so comes at the expense of a more complex
       language. How much more convenient would it be if we could have written
       our macros in C instead and used all of C's features to generate our
       code instead?")
    (h2 "Metaprogramming in Lisp")
    (p "Lisp allows us to do just that, we can write macros in a safe and
       structured way in Lisp itself. This is possible because of the syntax,
       or rather non-syntax of Lisp. Take the following expression:")
    (pre
      (code (@ (class "language-lisp"))
"(/ (+ (- b)
       (sqrt (- (* b b)
                (* 4 a c))))
    (* 2 a))"))
    (p "This is the formula which solves the quadratic equation (the first
       solution the be precise). If you squint your eyes you can make out a
       tree structure. In Lisp we write our program by writing the abstract
       syntax tree (AST) directly instead of hiding the AST behind some
       unrelated syntax. The AST is what the compiler will operate on to
       generate machine code. And since the AST is just a tree structure we can
       manipulate it like any other tree structure. After all, there is nothing
       sacred about the AST, it is just another data structure which will be
       manipulated by the compiler, so we can hook into the compiler and
       manipulate the data ourselves.")
    (h3 "Implementing local bindings")
    (p "Let us for the sake of argument assume that Lisp did not have any way
       of creating local bindings. If we want to bind a value to a variable we
       instead have to create an anonymous function, which has the bindings we
       want as parameters, and immediately apply it to the values we want to
       bind.")
    (p "Assume we want to get the current time from a clock and the current
       temperature from a thermometer. We then want to log those two values
       before doing some sort of calculation. We cannot fetch a new value every
       time we need it because the value might be different, we need to get the
       values once and bind them.")
    (pre
      (code (@ (class "language-lisp"))
"((lambda (t θ)
   (log-temperature θ)
   (log-time t)
   (do-something t θ)) (get-current-time)
                       (get-current-temperature))"))
    (p "This is just awful! It is easy to get a detail like the order of
       arguments wrong, it is ugly, things that belong together conceptually
       are separate, and if we had not been told the reason for this convoluted
       construct we would have to guess the intention behind it.")
    (p "We can invent a special form for this case. First we need to give it an
       idiomatic name like " (code "let") ", then we group the bindings
       together and put them at the beginning and enclosed in a pair of
       parentheses to make them separate form the body of the form.")
    (pre
      (code (@ (class "language-lisp"))
"(let ((t (get-current-time))
      (θ (get-current-temperature)))
  (log-temperature θ)
  (log-time t)
  (do-something t θ)"))
   (p "This is much better. Of course such a useful form is built into pretty
      much every Lisp, but if it wasn't we could have simply retrofitted it to
      the language, made it into a library and sent it out to other people to
      use.  I admit, this example is rather trivial, but it still serves as a
      good illustration: " (code "let") " could not have been implemented as a
      function because it completely breaks how Lisp evaluates s-expressions.")
   (h3 "Lisp in Lisp")
   (p "The implication of this simple example is that most of the “features”
      Lisp has are implemented in Lisp itself and can be reduced down to a
      small set of core features. Structures, object-oriented programming or
      loops can be simply added to Lisp.")
   (p "Compare this to other languages: if there is feature you want you first
      have to convince the standards committee that it is a good idea, then
      wait for the committee to agree upon an implementation and publish a new
      standard (and most likely you will have to wait for the committee to
      schedule a meeting in the first place), then you have to wait for
      implementations to adopt the new feature, then you have to wait for other
      people to transition to the new version, and then finally you can use
      your new feature in production. This is of course assuming that your
      feature is considered general enough by the committee and not too
      specific to your use-case.")
   (p "In Lisp none of this is an issue. Individuals can simply write their own
      implementations and publish a library. The community can then adopt the
      library and through common consensus the library gains popularity until
      it becomes as popular as if it was in the standard.")
   (h2 "OK, but why?")
   (p "It is easy to see why being able to create big additions like
      object-oriented programming would be valuable, but most of the times you
      will never need to create anything as large as CLOS (Common Lisp Object
      System). Does this level of metaprogramming offer any advantages to the
      average user or would we be better off just picking a language that
      already has all those big features? After all, it doesn't really matter "
      (em "how") " a language feature is implemented, only that you can use
      it.")
   (p "This line of thinking assumes that creating new features is hard any
      only worth the effort for big features. Who in their right mind would
      want change a language just for a one-off deal? But the truth is that in
      Lisp writing small one-off macros is actually very easy and low-effort,
      so you can reap the benefits at a low cost")
   (p "Enough talk, let's see some actual code. In my "
      (a (@ (href "https://gitlab.com/HiPhish/guile-msgpack"))
        "guile-msgpack")
      " project I need to test whether objects have been correctly serialised
      into bytes. A full test case looks like this:")
   (pre (code (@ (class "language-scheme"))
";; test-bytevector= is a regular function defined only once somewhere else
(test-begin \"Single precision floating point numbers\")
(test-bytevector= (pack -0.0)
                  #vu8(#xCA #b10000000 #b00000000 #b00000000 #b00000000))
;; more test-cases here...
(test-end \"Single precision floating point numbers\")"))
   (p "This is not that bad, but there is still a lot of boilerplate code that
      drowns out the actual content to test. When we think about it, there is
      really only two pieces of information that matter: the object we want to
      pack and the bytes we want to compare the result to. Everything else is
      just fluff meant for for the machine. There is no reason a human should
      ever have to see or write this fluff. Instead we would much rather write
      down a " (em "specification") " as to what our tests entail, and have the
      compiler write the actual computer code for us. Here is what the end
      result looks like:")
   (pre (code (@ (class "language-scheme"))
"(test-cases \"Single precision floating point numbers\"
  (+0.0                (#xCA #b00000000 #b00000000 #b00000000 #b00000000))
  (-0.0                (#xCA #b10000000 #b00000000 #b00000000 #b00000000))
  (+inf.0              (#xCA #b01111111 #b10000000 #b00000000 #b00000000))
  (-inf.0              (#xCA #b11111111 #b10000000 #b00000000 #b00000000))
  (+nan.0              (#xCA #b01111111 #b11000000 #b00000000 #b00000000))
  (-nan.0              (#xCA #b01111111 #b11000000 #b00000000 #b00000000))
  (+3.1415927410125732 (#xCA #b01000000 #b01001001 #b00001111 #b11011011))
  (-3.1415927410125732 (#xCA #b11000000 #b01001001 #b00001111 #b11011011)))"))
   (p "This is much more concise, everything that is irrelevant vanishes from
      view. We could hand the code to a person who has never programmed in
      their life and that person would still be able to read and write test
      cases.")
   (p "I don't want to bore you with the implementation details, you can read
      the source code yourself if you want to. The final test specification
      language allows for slightly more complex specifications for repeating
      bytes, but even then it comes down to about 20 lines of code while being
      very generous with whitespace.")
   (h2 "Conclusion")
   (p "Metaprogramming allows us to extend a language with new features by
      defining how the written source code is to be transformed into a more
      low-level code. The user of a macro writes a " (em "specification") "of
      the problem, which the macro then translates into Lisp code.")
   (p "These extensions can be big new language feature like support for
      object-oriented programming, or small domain-specific extension which
      would be too specific to be included in the standard. These
      domain-specific languages can be used by domain experts who might not be
      Lisp programmers to formulate their computations.")
   (p "The mathematical notation allows me as a mathematician to express very
      complex facts clearly and precisely without having to become a linguist.
      In the same way Lisp can help non-programmers write complex programs in
      their own domain. And even as a programmer I appreciate being able to
      think on a higher level, rather than constantly being on the low level of
      gluing together APIs")))


`((title . "What is a programmable programming language?")
  (tags . ("lisp"))
  (content . ,content))
