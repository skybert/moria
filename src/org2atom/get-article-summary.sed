# include everything from the title to the first sub heading.
/^#+title:/I,/\*/ {
  /^[A-Z]/I {
    p
  } 
  /^$/ {
    p
  }
}


