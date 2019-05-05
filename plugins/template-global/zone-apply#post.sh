#!/bin/bash
: "${taito_util_path:?}"

echo
echo "TIP: Once you have fully configured the zone, run 'taito project settings'"
echo "to see how to create a new project."
echo

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
