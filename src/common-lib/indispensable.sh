#! /usr/bin/env bash

# by torstein.k.johansen@gmail.com

# You may override this log file in your script, otherwise, you'll get
# a log file called .<myscript>.log in your home directory.
log_file=$HOME/.$(basename $0).log

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

function print_and_log() {
  echo "$@"
  if [[ -n "$log_file" || -w $(dirname $log_file)]]; then
  echo "$@" >> $log_file
}

function make_dir() {
  for el in "$@"; do
    if [ ! -d "$el" ]; then
      run mkdir -p "$el"
    fi
  done
}
