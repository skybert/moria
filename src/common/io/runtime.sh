#! /usr/bin/env bash

# by torstein

function run() {
  "${@}" 1>>$log 2>>$log
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

function exit_on_error() {
  local code=$?
  if [ ${code} -gt 0 ]; then
    print_and_log "The command [${@}] run as user $USER $(red FAILED)" \
      "(the command exited with code ${code}), I'll exit now :-("
    print "See $log for further details."
    remove_file_if_exists $lock_file
    remove_pid_and_exit_in_error
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
  if [ -w $log ]; then
    log_call_stack
  fi
  
  exit 1
}

function exit_on_error() {
  local code=$?
  if [ ${code} -gt 0 ]; then
    print_and_log "The command [${@}] run as user $USER $(red FAILED)" \
      "(the command exited with code ${code}), I'll exit now :-("
    print "See $log for further details."
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
  if [ -z $log ]; then
    return
  fi

  # cannot use run wrapper her, it'll trigger an eternal loop.
  fail_safe_run mkdir -p $(dirname $log)
  fail_safe_run touch $log
  echo $(get_id) $@ >> $log
}

function print_and_log() {
  print "$@"
  log "$@"
}

function log_call_stack() {
  log "Call stack (top most is the last one, main is the first):"

  # skipping i=0 as this is log_call_stack itself
  for ((i = 1; i < ${#FUNCNAME[@]}; i++)); do
    echo -n  ${BASH_SOURCE[$i]}:${BASH_LINENO[$i-1]}:${FUNCNAME[$i]}"()" >> $log
    if [ -e ${BASH_SOURCE[$i]} ]; then
      echo -n " => " >> $log
      sed -n "${BASH_LINENO[$i-1]}p" ${BASH_SOURCE[$i]} | \
        sed "s#^[ \t]*##g" >> $log
    else
      echo "" >> $log
    fi
  done
}

