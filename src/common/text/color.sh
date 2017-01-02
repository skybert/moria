#! /usr/bin/env bash

# by torstein

## Returns the inputted string(s) as red
##
## $@: input string
function red() {
  if [[ "${output_format-""}" == "html" ]]; then
    printf "%s" "$*"
  else
    echo -e "\E[37;31m\033[1m${@}\033[0m"
  fi

}

## Returns the inputted string(s) as green
##
## $@: input string
function green() {
  if [[ "${output_format-""}" == "html" ]]; then
    printf "%s" "$*"
  else
    echo -e "\E[37;32m\033[1m${@}\033[0m"
  fi
}

## Returns the inputted string(s) as yellow
##
## $@: input string
function yellow() {
  if [[ "${output_format-""}" == "html" ]]; then
    printf "%s" "$*"
  else
    echo -e "\E[37;33m\033[1m${@}\033[0m"
  fi
}

## Returns the inputted string(s) as blue
##
## $@: input string
function blue() {
  if [[ "${output_format-""}" == "html" ]]; then
    printf "%s" "$*"
  else
    echo -e "\E[37;34m\033[1m${@}\033[0m";
  fi

}
