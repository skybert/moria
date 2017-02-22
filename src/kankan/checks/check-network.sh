# Emacs: -*- mode: sh; sh-shell: bash; -*-

check_that_we_have_network_connectivity() {
  ((number_of_tests++))
  ping -c 1 vg.no &> /dev/null || {
    flag_error "Couldn't ping the interweb (vg.no)"
  }
  echo -n "."
}
