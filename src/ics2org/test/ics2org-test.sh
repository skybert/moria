#! /usr/bin/env bash

# by torstein@escenic.com

## @override shunit2
setUp() {
  source "$(dirname "$0")/../lib/$(basename "$0" -test.sh)-lib.sh"
  ics=$(dirname "$0")/recurring-event.ics
}

test_can_spot_a_recurring_event() {
  if ! is_recurring_event "$(cat "${ics}")"; then
    fail "Couldn't spot a recurring event"
  fi
}

test_can_get_weekly_recurring_days() {
  local expected="MO TU WE TH FR"
  local actual=
  actual=$(get_weekly_recurring_days "$(cat "${ics}")")
  assertEquals "${expected}" "${actual}"
}

test_can_return_empty_on_non_weekly_recurring_days() {
  local actual=
  actual=$(get_weekly_recurring_days $(grep ^BOO "${ics}"))
  assertNull "${actual}"
}

test_can_return_recurring_events_for_the_next_month() {
  # don't want events on Sat + Sun
  local expected=22
  local actual=
  actual=$(get_recurring_events_for_the_next_month "$(cat ${ics})" | \
      grep TODO | \
      wc -l)
  assertEquals "${expected}" "${actual}"

  actual=
  actual=$(
    get_recurring_events_for_the_next_month "$(cat ${ics})" | \
      grep SCHEDULED | \
      wc -l)
}

test_can_spot_a_non_recurring_event() {
  if is_recurring_event "non sense"; then
    fail "Couldn't spot a non recurring event"
  fi
}

test_can_get_start_date_from_occuring_event() {
  local expected=2016-02-22T09:55:00
  local actual=
  actual=$(get_date_time $(grep ^DTSTART "${ics}"))
  assertEquals "${expected}" "${actual}"
}

test_can_get_time_from_date_time() {
  local date_time=2016-02-22T09:55:00
  local expected=09:55:00
  local actual=
  actual=$(get_time_from_date_time ${date_time})
  assertEquals "${expected}" "${actual}"
}

test_can_get_end_date_from_occuring_event() {
  local expected=2016-02-22T10:00:00
  local actual=
  actual=$(get_date_time $(grep ^DTEND "${ics}"))
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
