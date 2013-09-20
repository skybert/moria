
### common_bashing_exit_hook
## To make your script call this whenever it does a controlled exit,
## either by running through the script, call this hook.
##
## Put this line at the start of your script:
##
## trap common_bashing_exit_hook EXIT
##
## $@ :: signal
function common_bashing_exit_hook() {
  remove_pid
  remove_lock
  kill $$
}

### common_bashing_user_cancelled_hook
## Put this in your script to have it exit whenever the user hits the
## user pressing Ctrl+c or by someone sending a regular kill <PID>
## signal to it.
##
## Usage:
## trap common_bashing_user_cancelled_hook SIGHUP SIGINT
##
## $@ :: signal
function common_bashing_user_cancelled_hook() {
  print "User cancelled $(basename $0), cleaning up after me ..."
  common_bashing_exit_hook
}
