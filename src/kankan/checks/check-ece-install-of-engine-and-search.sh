#! /usr/bin/env bash

check_ece_install_have_installed_files() {
  local -a files=(
    /etc/default/ece
    /etc/escenic/ece-engine1.conf
    /etc/escenic/ece-search1.conf
    /etc/escenic/ece.conf
    /etc/escenic/engine/common/security/jaas.config
    /etc/escenic/engine/common/security/java.policy
    /etc/escenic/solr/editorial/schema.xml
    /etc/escenic/solr/presentation/schema.xml
    /etc/init.d/ece
    /etc/init.d/solr
    /opt/solr
    /opt/tomcat-engine1
    /opt/tomcat-engine1/escenic/lib
    /opt/tomcat-search1
    /opt/tomcat-search1/escenic/lib
    /var/cache/escenic
    /var/lib/escenic
    /var/lib/escenic/solr/editorial/core.properties
    /var/lib/escenic/solr/presentation/core.properties
    /var/log/escenic
    /var/run/escenic
  )

  for file in "${files[@]}"; do
    ((number_of_tests++))
    test -e "${file}" || {
      flag_error "Should have created ${file}"
    }

    if [ "${verbose-0}" -eq 1 ]; then
      echo "File exists as expected: ${file}"
    else
      echo -n "."
    fi
  done

}
