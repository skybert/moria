#! /usr/bin/env sed

/^BEGIN:VEVENT/,/^END:VEVENT/ {
  /^BEGIN:VEVENT/p
  /^DTSTART:/p
  /^DTSTART;TZID=/p
  # /^DTEND:/p
  
  /^SUMMARY:/p

  # description can be multi line
  /^DESCRIPTION:/,/^[A-Z]/ {
    s/This is an event reminder//
    /^DESCRIPTION:/p
    s/^[ ]/DESCRIPTION:/p
  }
}
