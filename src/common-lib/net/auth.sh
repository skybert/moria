#! /usr/bin/env bash

# by torstein

## Will return 1 if the user can access the URL.
## $1 user
## $2 pass
## $3 URL
function is_authorized_to_access_url() {
  curl --silent --connect-timeout 20 --head --user ${1}:${2} ${3} | \
    head -1 | \
    grep "200 OK" | \
    wc -l
}
