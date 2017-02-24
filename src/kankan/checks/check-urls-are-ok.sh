# Emacs: -*- mode: sh; sh-shell: bash; -*-

## OK means that a GET to the URL returns a status code of 200, 301 or
## 302 within a decent amount of time.
##
## One entry for each of the URLs you want to check in your
## ~/.kankan.conf:
##
## declare -ax url_ok_list=(
##   "http://fsf.org"
##   "http://gnu.org"
## )
check_url_list_returns_ok_resources() {
  for url in "${url_ok_list[@]}"; do
    ((number_of_tests++))

    curl --connect-timeout 2 --silent --head "${url}" |
      egrep "^HTTP.* (200|301|302)" > /dev/null || {
      flag_error "Couldn't GET ${url}"
    }

    if [ "${verbose-0}" -eq 1 ]; then
      printf "%s\n" "GET ${url} succeeded"
    else
      echo -n "."
    fi

  done
}
