#! /usr/bin/env sed

# echo commons-lang:commons-lang:jar:2.6:compile | sed -f mvn-ref-to-dec.sed

s#\(.*\)[:]\(.*\)[:]jar[:]\(.*\)[:]\(.*\)#<dependency>\n  <groupId>\1</groupId>\n  <artifactId>\2</artifactId>\n  <version>\3</version>\n</dependency>#

