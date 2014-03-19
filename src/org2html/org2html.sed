#! /usr/bin/env sed

# fix entities
s~<~\&lt;~g
s~>~\&gt;~g
#s~&~\&amp;~g

# headers
s~^#+title: \(.*\)~<h1>\1</h1>~gI
s~^\*\*\* \(.*\)~<h4>\1</h4>~
s~^\*\* \(.*\)~<h3>\1</h3>~
s~^\* \(.*\)~<h2>\1</h2>~

# source code
/^#+BEGIN_SRC/,/#+END_SRC/ {
  s~^#+BEGIN_SRC .*~<pre class="prettyprint">~
  s~^#+END_SRC~</pre>~

  # indent contents
  /^[^<]/ {
    s/^/  /
  }
}
/^#+begin_src/,/#+end_src/ {
  s~^#+begin_src .*~<pre class="prettyprint">~
  s~^#+end_src~</pre>~

  # indent contents, except for lines starting with a '<'
  /^[^<]/ {
    s/^/  /
  }
}

# quotes
s~^#+begin_quote~<blockquote>~
s~^#+end_quote~</blockquote>~

# monotype, non greedy matching
s~=\([^=]*\)=~<code>\1</code>~g

# bold & italics
s~\*\([^\*]*\)\*~<strong>\1</strong>~g
s~_\([^_]*\)_~<em>\1</em>~g

# lists
/^- /,/^- / {
  s/^- /<li>/
}

/^<li>/ {
  a </li>
}

/^$/,/^<li>/ {
  /^<li>/ {
    i <ul>
  }
}

/^<li>/,/^$/ {
  /^$/ {
    i </ul>
  }
}

s~^\[\[~\n\[\[~

# pictures & links
/\[\[/,/\]\]/ {
  # with alt
  s~\[\[\(.*.png\)\]\[\(.*\)\]\]~<div><img src="\1" alt="\2"/></div>~gI
  s~\[\[\(.*.gif\)\]\[\(.*\)\]\]~<div><img src="\1" alt="\2"/></div>~gI
  s~\[\[\(.*.jpg\)\]\[\(.*\)\]\]~<div><img src="\1" alt="\2"/></div>~gI

  # without alt
  s~\[\[\(.*.png\)\]\]~<div><img src="\1" alt="\1"/></div>~gI
  s~\[\[\(.*.jpg\)\]\]~<div><img src="\1" alt="\1"/></div>~gI

  # links with titles
  s~\[\[\(.*\)\]\[\(.*\)\]\]~<a href="\1">\2</a>~g

  # links without titles
  s~\[\[\(.*\)\]\]~<a href="\1">\1</a>~g
}

# paragraphs
/^$/,/^[A-Z]/ {
  /^[A-Z]/ {
    i <p>
  }
}

/^[^<][a-z]/,/^$/ {
  /^$/ {
    i </p>
  }
}

# Lastly, remove empty lines
/^$/d
