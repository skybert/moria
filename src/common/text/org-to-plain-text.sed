# strip formatting of montotyp, bold and underlined text
s~=\([^=]*\)=~\1~g
s~\*\([^\*]*\)\*~\1~g
s~_\([^_]*\)_~\1~g
