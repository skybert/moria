#! /usr/bin/env bash

# by torstein.k.johansen@gmail.com

# You may override this log file in your script, otherwise, you'll get
# a log file called .<myscript>.log in your home directory.
log_file=$HOME/.$(basename $0).log
lock_file=$HOME/.$(basename $0).log

function print_and_log() {
  print "$@"
  if [[ -n "$log_file" || -w $(dirname $log_file) ]]; then
    echo "$@" >> $log_file
  fi
}

function make_dir() {
  local el=
  for el in "$@"; do
    if [ ! -d "$el" ]; then
      run mkdir -p "$el"
    fi
  done
}

function create_lock() {
  if [ -e $lock_file ]; then
    # TODO could exit in error here.
    return
  fi

  run touch $lock_file
}

function remove_lock() {
  remove_file_if_exists $lock_file
}

## $1 :: the file.
function get_age_of_file_in_seconds_since_epoch() {
  local file=$1
  if [ ! -e $file ]; then
    return
  fi

  stat --format %Y $file
}

function get_human_time() {
  local seconds_worked=$1

  local days=$(( seconds_worked / ( 60 * 60 * 24 ) ))
  local seconds_left=$(( seconds_worked - ( $days * 60 * 60 * 24 ) ))
  local hours=$(( seconds_left / ( 60 * 60 ) ))
  local seconds_left=$(( seconds_left - ( $hours * 60 * 60 ) ))
  local minutes=$(( seconds_left / 60 ))
  local seconds_left=$(( seconds_left - $minutes * 60 ))

  echo "${hours}h ${minutes}m ${seconds_left}s"
}

function run() {
  "${@}" 1>>$log_file 2>>$log_file
  exit_on_error $@
}

function fail_safe_run() {
  "${@}"
  if [ $? -gt 0 ]; then
    echo $(basename $0) $(red FAILED) "executing the command [$@]" \
      "as user" ${USER}"." \
      $(basename $0) "will now exit." | \
      fmt
    exit 1
  fi
}

function remove_file_if_exists() {
  if [ -w "$1" ]; then
    run "$1"
  fi
}

function remove_pid_and_exit_in_error() {
  if [[ -z $pid_file && -e $pid_file ]]; then
    rm $pid_file
  fi

  # this method is also used from bootstrapping methods in scripts
  # where the log file may not yet exist, hence, we test for its
  # existence here before logging the call/stack trace.
  if [ -w $log_file ]; then
    log_call_stack
  fi

  exit 1
}

function exit_on_error() {
  local code=$?
  if [ ${code} -gt 0 ]; then
    print_and_log "The command [${@}] run as user $USER $(red FAILED)" \
      "(the command exited with code ${code}), I'll exit now :-("
    print "See $log_file for further details."
    remove_file_if_exists $lock_file
    remove_pid_and_exit_in_error
  fi
}

function get_id() {
  echo "[$(basename $0)]"
}

function print() {
  if [[ "$quiet" == 1 ]]; then
    echo $@ | fmt
    return
  fi

  # we break the text early to have space for the ID.
  local id="$(get_id) "
  local text_width=$(( 80 - $(echo $id | wc -c) ))
  echo $@ | fmt --width $text_width | sed "s~^~${id}~g"
}

## Will log all messages past to it.
##
## - If the parent directory of the log file doesn't exist, the method
## will try to create it.
##
## - If the log file doesn't exist, the method will try to create it.
##
## $@ :: list of strings
function log() {
  if [ -z $log_file ]; then
    return
  fi

  # cannot use run wrapper her, it'll trigger an eternal loop.
  fail_safe_run mkdir -p $(dirname $log_file)
  fail_safe_run touch $log_file
  echo $(get_id) $@ >> $log_file
}

function log_call_stack() {
  log "Call stack (top most is the last one, main is the first):"

  # skipping i=0 as this is log_call_stack itself
  for ((i = 1; i < ${#FUNCNAME[@]}; i++)); do
    echo -n  ${BASH_SOURCE[$i]}:${BASH_LINENO[$i-1]}:${FUNCNAME[$i]}"()" >> $log_file
    if [ -e ${BASH_SOURCE[$i]} ]; then
      echo -n " => " >> $log_file
      sed -n "${BASH_LINENO[$i-1]}p" ${BASH_SOURCE[$i]} | \
        sed "s#^[ \t]*##g" >> $log_file
    else
      echo "" >> $log_file
    fi
  done
}

