##          author: torstein@escenic.com

get_date() {
  local line=$1
  IFS=: read key value <<< "$line"

  if [[ "$key" == "DTSTART;TZID"* || "$key" == "DTEND;TZID"* ]]; then
    echo "$value" | \
      sed -r 's#([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2}).*#\1-\2-\3T\4:\5:\6#'
  elif [[ "$key" == DTSTART ]]; then
    echo "$value" | \
      sed -r 's#([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2}).*#\1-\2-\3T\4:\5:\6Z#'
  else
    echo $line
  fi
}

is_recurring_event() {
  local rrule_line=$1
  if [[ "${rrule_line}" == RRULE* ]]; then
    return 0
  else
    return 1
  fi
}
