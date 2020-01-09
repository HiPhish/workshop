.. default-role:: code

- The content and related metadata (like `css`) of a blog post should not be on
  a lower lever (inside the `post` data) than other data like `next`.

- Get rid of Bootstrap and jQuery. Enough said.

- The periods in the side bar of the blog should show the months for the
  current year.

- Make the footer of each post (the one with previous/next) stick to the bottom

- Tables in blogs need to be decorated in CSS instead of putting Bootstrap
  classes there.

- Write a `template` macro for designing page templates


De-bootstrapping progress
#########################

The following things still fall apart without Bootstrap:

- Grid Framework gallery layout is all messed up


Page template macro
###################

Instead of using a function and awkward bindings there should be a `template`
macro, something along these lines:

.. code-block:: scheme

   (template parent (binding ...)
     body ...)

The `parent` is the parent tamplate or `#f`, and the bindings are bindings from
the parent we wish to make use of inside the body expressions.
