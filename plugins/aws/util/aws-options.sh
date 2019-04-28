#!/bin/bash

if [[ $AWS_ACCESS_KEY_ID ]]; then
  profile="env var key"
  aws_options=""
else
  profile=${taito_provider_user_profile:-$taito_organization}
  profile=${profile:-default}
  aws_options="--profile $profile"
fi
