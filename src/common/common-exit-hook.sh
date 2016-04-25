start_time=$(date +%s)

my_exit_hook() {
  local exit_status=$?
  local end_time=$(date +%s)
  local it_took=$(echo "It took" $(( end_time - start_time )) "seconds")

  if [ ${exit_status} -eq 0 ]; then
    echo $(basename $0)  $(green SUCCESS ) ${it_took}
  else
    echo $(basename $0)  $(red FAILED ) ${it_took}", last messages in ${log_file}:"
    tail -20 ${log_file}
  fi

  exit ${exit_status}
}

trap my_exit_hook EXIT
