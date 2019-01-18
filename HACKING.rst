.. default-role:: code

######################
 Hacking the Workshop
######################

I'll try to explain some of the basic ideas behind this software for my future
self and anyone who happens to stumble upon it.


Fundamental ideas
#################

The workshop is built statically, this means that the entire content of the
website is generated at once and uploaded to a web server. The server can then
just serve the requested files statically.

The Workshop is written in the GNU Guile implementation of Scheme and makes
extensive used of the SXML_ library which ships with Guile to build up the HTML
documents.

.. _SXML: info:guile.info#SXML

Since the static site generator (SSG) is written from scratch, this gives me
the ability to write everything to my wishes, rather than having to hammer an
existing solution into the shape I want. This also means I can make a lot of
information (like the target URL) implicit in the directory structure instead
of having to spell it out explicitly in a file.


Passing and enriching data
==========================

The term *data* refers to information needed to build up a particular HTML
page. A data object is some type of dictionary, in this implementation that's
an association list, but any dictionary type would work. The keys are the
"type" of data content, such as the `title`, the `url` or the `content`. The
value depends on the type and can be anything in theory. Usually it's a string
or an SXML tree, but it can even be a `date` object as defined by SRFI-19_. It
depends on the template which data is needed.

.. _SRFI-19: info:guile.info#SRFI-19

Data is what is being passed around between procedures, and it can be
"enriched". Enrichment is the process of adding new entries to the data
dictionary. These new entries are allowed to overwrite existing ones, so care
must be taken to not mutate objects which will be used by other procedures
(association lists are very good in this regard).

One particular notion in regards to data is that of *metadata* and *content*.
Content is an SXML tree which will eventually be rendered as HTML, while
metadata is everything else.


Templates
=========

A template is a function, it takes in a data object and returns a new enriched
data object. This process usually means that the template takes the metadata,
generates SXML trees, splices them into the content, and then returns the newly
enriched data.

Templates can be composed, and it is the duty of the web site author to ensure
that every template in that chain gets the required data. Usually as data moves
through the templating chain the content grows while more and more of the
metadata becomes irrelevant, until the very last template only returns the full
HTML page content.


Readers and generators
======================

A reader is a procedure which accepts one file path and returns data read from
that file. The data might have to be further enriched first before it can be
processed (e.g. we infer the data and slug of blog posts based on the file
path). This enrichment is not performed by the reader.

Generators are a bit of a messy concept. Usually the term would refer to a
procedure which *generates* an output file, but in this case a generators is
something that generates something. For example, there is a blog generator
which generates an entire blog, all of its pages, based on the specifications
for a blog.

A generator is also a procedure which takes an output file path and produces
that file, using whatever means are defined in its body. Usually such a
generator is created by another procedure. For instance, the verbatim generator
is a lambda like this:

.. code:: scheme

   (define (verbatim-generator source)
     "Produce a generator which copies a source file to a destination location."
     (λ (destination)
       (copy-file source destination)))


Content
=======

Content (meaning content files no, not content data) is what we want on the
website, but it is not yet in its final form. Some content is just files (such
as images) which get copied over verbatim, but other content is files which
need to be *read* and processed instead. There is is usually a 1:1
correspondence between a file and an HTML output, but it does not have to be so
(e.g. the index of a blog is generated from many blog posts).


Individual content elements
###########################

The global navigation menu
==========================

The menu at the top of every page is built entirely using HTML and CSS without
any Javascript. It supports one level of nesting and has a hamburger toggle
button for mobile devices based on the checkbox hack.

.. code:: html
   <nav id="main-navbar">
     <input type="checkbox" id="hamburger" hidden="hidden">
     <div>
       <a href="/">Home page</a>
       <label for="hamburger" hidden="hidden"></label>
     </div>
     <ul>
       <li>
         <a href="#">Group 1</a>
         <ul>
           <li><a href="#">Item 1</a></li>
           <li hidden="hidden"></li>
           <li><a href="#">Item 2</a></li>
           <li><a href="#">Item 3</a></li>
         </ul>
       </li>
       <li>
         <a href="#">Item without group</a>
       </li>
       <li class="push-end">
         <a href="#">This will be pushed right/down</a>
       </li>

There are three elements in the `nav`: a (hidden) checkbox, the `div`
containing the home link and the (hidden) hamburger "button", and the list of
actual navigation items. An item may contain a nested list. Empty and hidden
list items are separators, they will be displayed using CSS, but must be hidden
from non-graphical user agents.

Here is the hack: When the screen gets small enough enough we hide the list and
we show the hamburger button by setting its `display` CSS property to `block`
or something, overriding how the browser interprets the `hidden` attribute. Due
to `hidden` being an HTML attribute, the label will still remain hidden on
other user agents, such as screen readers. Now when the user clicks the
hamburger label, it sets the `:checked` pseudo-class of the checkbox, which
allows us to override the `display` of the list.

.. code:: css

   nav#main-navbar > input#hamburger:checked ~ ul {
       display: flex;
   }

The remainder of the CSS is just about making the whole thing pretty. There is
a couple of improvements that could be made:

- Allow toggling the menu items instead of hovering over them. This would
  require a lot of radio button hackery to make the toggles work well
- Allow toggling on mobile as well. Currently in mobile nesting is not
  supported because it would require the ability to toggle instead of hover.
  See the first point.
- The checkbox requires an `id` attribute, which is an ugly hack. The standard
  allows us to embed the input inside the label, but in order to select the
  list based on a such nested checkbox we would need a sort of "cousin"
  selector, which is not possible in CSS.
