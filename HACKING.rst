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
