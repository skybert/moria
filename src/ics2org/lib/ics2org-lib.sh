##          author: torstein@escenic.com

get_date_time() {
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

get_start_date_time() {
  local event=$1
  get_date_time $(echo "${event}" | grep ^DTSTART)
}

get_end_date_time() {
  local event=$1
  get_date_time $(echo "${event}" | grep ^DTEND)
}

## $1 :: event ICS
is_recurring_event() {
  local event=$1
  local rrule_line=$(echo "$event" | grep ^RRULE)

  if [[ "${rrule_line}" == RRULE* ]]; then
    return 0
  else
    return 1
  fi
}

get_weekly_recurring_days() {
  local event=$1
  local rrule_line=$(echo "$event" | grep ^RRULE)
  echo "${rrule_line##*BYDAY=}" | sed 's#[,]# #g'
}

get_summary() {
  local event=$1
  local summary=$(echo "$event" | grep ^SUMMARY)
  echo "${summary##SUMMARY:}"
}

## $1 :: event ICS
get_recurring_events_for_the_next_month() {
  local event=$1
  if ! is_recurring_event "${event}"; then
    return
  fi

  local days=$(get_weekly_recurring_days "${event}")
  if [ -z "${days}" ]; then
    return
  fi

  local start_time=$(
    get_time_from_date_time $(get_start_date_time "${event}"))

  local now=$(date +%s)
  # today + 30 days is one month
  local next_month=$((now + (60 * 60 * 24 * 30)))
  local day_step=$((60 * 60 * 24))
  local summary=$(get_summary "${event}")

  for ((i = ${now}; i <= ${next_month}; i += ${day_step})); do
    for day in ${days}; do
      local dow=$(date -d "@${i}" +%a | tr '[a-z]' '[A-Z]')
      if [[ ${day} == ${dow:0:2} ]]; then
        cat <<EOF
* TODO ${summary}
  SCHEDULED: <$(date -d "@${i}" '+%Y-%m-%d') ${start_time}>

$(get_description_from_ics "${event}")

EOF
      fi
    done
  done


}

get_time_from_date_time() {
  local date_time=$1
  echo "${date_time##*T}"
}

get_description() {
  local file=$1
  get_description_from_ics "$(cat "$file")"
}

get_description_from_ics() {
  echo "$*" | \
    sed -n 's#DESCRIPTION:##p' | \
    sed 's#n\([A-Z]\)#\n\1#g' | \
    sed 's#n\([0-9]\)#\n\1#g' | \
    sed 's#n$#\n#g'
}
