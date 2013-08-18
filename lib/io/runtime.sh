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

