#! /usr/bin/env bash

# by torstein

## Returns 1 if the passed argument is a number, 0 if not.
## $1: the value you wish to test.
function is_number() {
  for (( i = 0; i < ${#1}; i++ )); do
    if [ $(echo ${1:$i:1} | grep [0-9] | wc -l) -lt 1 ]; then
      echo 0
      return
    fi
  done
  
  echo 1
}
