# include everything from the title to the first sub heading.
/^#+title:/,/\*/ {
  /^[A-Z]/ {
    p
  } 
  /^[a-z]/ {
    p
  } 
}

/^#+TITLE:/,/\*/ {
  /^[A-Z]/ {
    p
  } 
  /^[a-z]/ {
    p
  } 
}

