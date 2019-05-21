#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_zone:?}"

name=$1

if [[ -z $name ]] || [[ $name == "monitoring" ]]; then
  echo "Google Stackdriver monitoring channels:"
  gcloud -q --project "${taito_zone}" alpha monitoring channels list
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
