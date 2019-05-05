#!/bin/bash
: "${taito_util_path:?}"

echo
echo "TIP: Once you have configured the zone, you can create a new project on"
echo "this zone like this:"
echo
echo "1) Configure your personal config file (~/.taito/taito-config.sh) or"
echo "   organizational config file (~/.taito/taito-config-${taito_organization_abbr:-myorg}.sh)"
echo "   according to the example settings displayed by 'taito project settings'."
echo "2) Create a new project based on server-template by running"
echo "   'taito [-o ${taito_organization_abbr:-myorg}] project create: server-template'"
echo
echo "This is only a tip. You don't have to do this right now, and you can display"
echo "this tip also later by running 'taito project settings'."
echo "Press enter to continue."
read -r

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
