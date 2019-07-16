#!/bin/bash -e

taito::substitute_variable_values_in_file () {
  # TODO: REMOVE THESE. ALWAYS USE PIPING!
  local source_file=$1
  local dest_file=$2

  # Substitute environment variables
  if [[ $dest_file ]]; then
    (
      ${taito_setv:?}
      perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg' \
        $source_file > $dest_file
    )
  else
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg'
  fi
}
export -f taito::substitute_variable_values_in_file

taito::show_db_proxy_details () {
  . "${taito_util_path:?}/database_username_password.bash"

  echo "- host: 127.0.0.1"
  echo "- port: ${database_port:-}"
  echo "- database: ${database_name:-}"

  if [[ ${taito_mode:-} != "ci" ]]; then
    echo "- username and password:"
    echo "  * Your personal database username and password (if you have one)"
    if [[ "${database_mgr_username:-}" ]]; then
      echo "  * ${database_mgr_username} / ${database_build_password:-}"
    fi
    if [[ "${database_app_username:-}" ]]; then
      echo "  * ${database_app_username} / ${database_app_password:-}"
    fi
  fi
}
export -f taito::show_db_proxy_details
