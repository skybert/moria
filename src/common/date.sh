# Date and time related functions
# by torstein.k.johansen@conduct.no

## The method returns the age of the file when its contents where last
## change in seconds since epoch.
##
## $1 :: the file.
function get_age_of_file_in_seconds_since_epoch() {
  local file=$1
  if [ ! -e $file ]; then
    return
  fi

  stat --format %Y $file
}

## $1 :: seconds
function get_human_time() {
  local seconds_worked=$1

  local days=$(( seconds_worked / ( 60 * 60 * 24 ) ))
  local seconds_left=$(( seconds_worked - ( $days * 60 * 60 * 24 ) ))
  local hours=$(( seconds_left / ( 60 * 60 ) ))
  local seconds_left=$(( seconds_left - ( $hours * 60 * 60 ) ))
  local minutes=$(( seconds_left / 60 ))
  local seconds_left=$(( seconds_left - $minutes * 60 ))

  echo "${hours}h ${minutes}m ${seconds_left}s"
}

# echo $(get_human_time $(get_age_of_file_in_seconds_since_epoch ~/.emacs))
