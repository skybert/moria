# Emacs: -*- mode: sh; sh-shell: bash; -*-

check_that_we_have_network_connectivity_can_ping() {
  ping -c 1 -W 2 vg.no &> /dev/null || {
    flag_error "Couldn't ping the interweb (vg.no)"
  }
}

check_that_we_have_network_connectivity_can_get_http_resource() {
  curl -s http://vg.no &> /dev/null || {
    flag_error "Couldn't GET the interweb (vg.no)"
  }
}
