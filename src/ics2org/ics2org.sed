#! /usr/bin/env sed

/^BEGIN:VEVENT/,/^END:VEVENT/ {
  /^DTSTART:/ {
    s/^DTSTART:\([0-9][0-9][0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\).*T.*/SCHEDULED: <\1-\2-\3>/p
  }

  # /^DTEND:/p
  
  /^SUMMARY/ {
    s/^SUMMARY:/** TODO /p
  }
  
  # description can be multi line
  /^DESCRIPTION:/,/^[A-Z]/ {
    s/This is an event reminder//
    s/^DESCRIPTION://p
    /^[ ]/p
  }
}
