#! /usr/bin/env sed

## SED script for converting ORG files into Markdown.
##
## by torstein.k.johansen at gmail dot com

# title
s#\#+title:\(.*\)#title: \1#

# h1s
s#[*][*][*][*][*][*] \(.*\)$#\#\#\#\#\#\# \1#
s#[*][*][*][*][*] \(.*\)$#\#\#\#\#\# \1#
s#[*][*][*][*] \(.*\)$#\#\#\#\#\1#
s#[*][*][*] \(.*\)$#\#\#\# \1#
s#[*][*] \(.*\)$#\#\# \1#
s#[*] \(.*\)$#\# \1#

# lists
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

# links, I do it in two steps here
s#[[][[]\(.*\)[]][]].*#\1#
s#\(http.*\)[]][[]\(.*\)#[\2](\1)#

