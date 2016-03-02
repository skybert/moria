#! /usr/bin/env bash

# by torstein@escenic.com

## @override shunit2
setUp() {
  source "$(dirname "$0")/../lib/$(basename "$0" -test.sh)-lib.sh"
  ics=$(dirname "$0")/recurring-event.ics
}

test_can_spot_a_recurring_event() {
  if ! is_recurring_event $(grep ^RRULE "${ics}"); then
    fail "Couldn't spot a recurring event"
  fi
}

test_can_spot_a_non_recurring_event() {
  if is_recurring_event "non sense"; then
    fail "Couldn't spot a non recurring event"
  fi
}

test_can_get_start_date_from_occuring_event() {
  local expected=2016-02-22T09:55:00
  local actual=
  actual=$(get_date $(grep ^DTSTART "${ics}"))
  assertEquals "${expected}" "${actual}"
}

test_can_get_end_date_from_occuring_event() {
  local expected=2016-02-22T10:00:00
  local actual=
  actual=$(get_date $(grep ^DTEND "${ics}"))
  assertEquals "${expected}" "${actual}"
}

## @override shunit2
tearDown() {
  :
}

main() {
  . "$(dirname "$0")"/shunit2/source/2.1/src/shunit2
}

main "$@"
