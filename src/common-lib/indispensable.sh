#! /usr/bin/env bash

# by torstein.k.johansen@gmail.com

function run() {
  if [[ -n "$log_file" ]]; then
    "$@" 1>> $log_file 2>> $log_file
  else
    "$@"
  fi

  if [ $? -gt 0 ]; then
    print "The command <$@> failed :-("
    exit 1
  fi
}

function print() {
  echo "$@"
}

function make_dir() {
  for el in "$@"; do
    if [ ! -d "$el" ]; then
      run mkdir -p "$el"
    fi
  done
}
