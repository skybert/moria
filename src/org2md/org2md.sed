#! /usr/bin/env sed

## SED script for converting ORG files into Markdown.
##
## by torstein.k.johansen at gmail dot com

# title
s#\#+title:\(.*\)#title: \1#

# h1s
s#[ ]*<h1>\([^<]*\)</h1>#\# \1#
s#[ ]*<h2>\([^<]*\)</h2>#\#\# \1#
s#[ ]*<h3>\([^<]*\)</h3>#\#\#\# \1#
s#[ ]*<h4>\([^<]*\)</h4>#\#\#\#\# \1#
s#[ ]*<li>#- #

# elements that can get lost
s#[ ]*<[/]*p>##
s#[ ]*<[/]li>##
s#[ ]*<[/]pre>##
s#[ ]*<[/]*ul>##
s#[ ]*<[/]*div>##

# code
/^#+begin_src/,/#+end_src/I {
  s~^#+begin_src .*~```~
  s~^#+end_src~```~
}

# monotype, non greedy matching
s~=\([^=]*\)=~```\1```~g

