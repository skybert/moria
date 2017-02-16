# Emacs: -*- mode: sh; sh-shell: bash; -*-

has_initialised_ece_instance_check=0

declare -a url_list_vdf=()
declare -a url_list_language=()

init_check_ece_instances() {
  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    host_and_port="${el}"
    http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"
    publication="${ece_instance_host_port_and_publication_map[${el}]}"
    content_type="${ece_instance_host_port_and_content_type_map[${el}]}"

    url_list_200_ok_and_xml=(
      http://"${http_auth}"@${host_and_port}/webservice/index.xml
      http://"${http_auth}"@${host_and_port}/webservice/escenic/publication/${publication}/model/content-type/${content_type}
      ${url_list_200_ok_and_xml[@]}
    )

    url_list_vdf=(
      http://"${http_auth}"@${host_and_port}/webservice/escenic/publication/${publication}/model/content-type/${content_type}
      ${url_list_vdf[@]}
    )

    url_list_language=(
      http://"${http_auth}"@${host_and_port}/webservice/escenic/content/state/published/editor
      ${url_list_language[@]}
    )
  done

  has_initialised_ece_instance_check=1
}

check_that_search_is_working() {
  for el in "${!ece_instance_host_port_and_http_auth_map[@]}"; do
    ((number_of_tests++))
    local host_and_port="${el}"
    local http_auth="${ece_instance_host_port_and_http_auth_map[${el}]}"

    local uri="http://${host_and_port}/webservice/search/*/"
    local -i total_results=0
    total_results=$(
      curl -s  -u "${http_auth}" "${uri}"  |
        grep totalResults |
        tail -n 1 |
        sed -n -r 's#.*totalResults="([^"]*)".*#\1#p')
    if [ "${total_results}" -gt 0 ]; then
      echo -n "."
    else
      flag_error "Searching isn't working using ${uri}"
    fi
  done
}

_check_language_state_translation() {
  if [ "${has_initialised_ece_instance_check}" -eq 0 ]; then
    init_check_ece_instances
  fi

  local language_name=$1
  local string_to_test_for=$2
  local locales=$3

  for el in "${url_list_language[@]}"; do
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

check_norwegian_state_translation() {
  _check_language_state_translation "Norwegian" "Publisert" "no nb"
}

check_swedish_state_translation() {
  _check_language_state_translation "Swedish" "Publicerad" "sv"
}

check_german_state_translation() {
  _check_language_state_translation "German" "Publiziert" "de"
}

check_list_of_urls_that_should_return_vdf() {
  if [ "${has_initialised_ece_instance_check}" -eq 0 ]; then
    init_check_ece_instances
  fi

  for el in "${url_list_vdf[@]}"; do
    ((number_of_tests++))
    local uri_fragment=${el##http://${host_and_port}}

    curl -I -s "${el}" |
      grep --quiet -i "^Content-Type: application/vnd.vizrt.model+xml"
    if [ $? -ne 0 ]; then
      flag_error "${uri_fragment} did NOT return VDF"
    fi

    if [ "${verbose-0}" -eq 1 ]; then
      echo "Verified VDF: ${uri_fragment}"
    else
      echo -n "."
    fi
  done
}
