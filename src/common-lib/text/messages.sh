#! /usr/bin/env bash

# by torstein

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

