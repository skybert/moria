#! /usr/bin/env sed

/^BEGIN:VEVENT/,/^END:VEVENT/ {
  /^BEGIN:VEVENT/p
  /^END:VEVENT/p
  /^DTSTART:/p
  /^RRULE:/p
  /^DTSTART;TZID=/p
  /^SUMMARY:/p

  # description can be multi line
  /^DESCRIPTION:/,/^[A-Z]/ {
    s/This is an event reminder//
    /^DESCRIPTION:/p
    s/^[ ]/DESCRIPTION:/p
  }
}
