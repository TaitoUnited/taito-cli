#!/bin/bash
# NOTE: This bash script is run also directly on host.

taito::executing_start () {
  ${taito_setv:?}
}
export -f taito::executing_start

taito::executing_end () {
  set +x
}
export -f taito::executing_end

taito::print_plugin_title () {
  local path="${taito_plugin_path:?}"
  local name="${path##*/}"
  echo
  echo -e "${taito_command_context_prefix:-}${H1s:?}${name}${H1e:?}"
}
export -f taito::print_plugin_title

taito::print_title () {
  echo
  echo -e "${H2s:?}${1}${H2e:?}"
}
export -f taito::print_title

taito::print_note_start () {
  echo -e "${NOTEs:?}"
}
export -f taito::print_note_start

taito::print_note_end () {
  echo -e "${NOTEe:?}"
}
export -f taito::print_note_end
