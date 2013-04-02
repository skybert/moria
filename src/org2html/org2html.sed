#! /usr/bin/env sed

# headers
s~^#+TITLE: \(.*\)~<h1>\1</h1>~
s~^\* \(.*\)~<h2>\1</h2>~
s~^\*\* \(.*\)~<h3>\1</h3>~
s~^\*\*\* \(.*\)~<h4>\1</h4>~

# source code
/^#+BEGIN_SRC/,/#+END_SRC/ {
  s~^#+BEGIN_SRC .*~<pre class="prettyprint">~
  s~^#+END_SRC~</pre>~

  # indent contents
  /^[^<]/ {
    s/^/  /
  }
}

# monotype
s~=\(.*\)=~<code>\1</code>~

# lists
/^-/,/^-/ {
  s/^-/<li>/
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
  s~\[\[\(.*.png\)\]\[\(.*\)\]\]~<div><img src="\1" alt="\2"/></div>~g
  s~\[\[\(.*.jpg\)\]\[\(.*\)\]\]~<div><img src="\1" alt="\2"/></div>~g

  # without alt
  s~\[\[\(.*.png\)\]\]~<div><img src="\1" alt="\1"/></div>~g
  s~\[\[\(.*.jpg\)\]\]~<div><img src="\1" alt="\1"/></div>~g

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

# fix entities
/^[ ]*[<]{1}/ {

}

# Lastly, remove empty lines
/^$/d
