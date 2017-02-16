# Emacs: -*- mode: sh; sh-shell: bash; -*-
has_initialised_ece_vf_6969_section_page_translation=0

init_check_ece_vf_6969_section_page_translation() {
  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    host_and_port="${el}"
    http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"
    publication="${ece_instance_host_port_and_publication_map[${el}]}"
    content_type="${ece_instance_host_port_and_content_type_map[${el}]}"

    url_list_pool_state_language=(
      http://"${http_auth}"@${host_and_port}/webservice/escenic/pool/state/published/editor
      ${url_list_pool_state_language[@]}
    )
  done

  has_initialised_ece_vf_6969_section_page_translation=1
}

_check_section_page_state_translation() {
  if [ "${has_initialised_ece_vf_6969_section_page_translation}" -eq 0 ]; then
    init_check_ece_vf_6969_section_page_translation
  fi

  local language_name=$1
  local string_to_test_for=$2
  local locales=$3

  for el in "${url_list_pool_state_language[@]}"; do
    local uri_fragment=${el##http://${host_and_port}}

    local count=

    for locale in ${locales}; do
      ((number_of_tests++))
      count=$(
        curl -s \
             --header "Accept-Language: ${locale}" \
             "${el}" |
          xmllint --format - |
          grep -c -w "${string_to_test_for}")
      if [ "${count}" -lt 1 ]; then
        flag_error "${uri_fragment}" "did not have a ${language_name} version for locale ${locale}"
      fi

      if [ "${verbose-0}" -eq 1 ]; then
        echo "Verified ${language_name} language for locale ${locale}: ${uri_fragment} ..."
      else
        echo -n "."
      fi
    done
  done
}

check_norwegian_section_page_state_translation() {
  _check_section_page_state_translation "Norwegian" "Publisert" "no nb"
}

check_swedish_section_page_state_translation() {
  _check_section_page_state_translation "Swedish" "Publicerad" "sv"
}

check_german_section_page_state_translation() {
  _check_section_page_state_translation "German" "Publiziert" "de"
}
