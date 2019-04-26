#!/bin/bash
: "${taito_util_path:?}"

options=" ${*} "

profile=${aws_org_id:-default}
if [[ ${taito_type:-} == "zone" ]]; then
  profile="${profile}-admin"
fi

if ! aws configure --profile "$profile" list &> /dev/null || \
   [[ "${options}" == *" --reset "* ]]; then
  echo "Authenticating with profile $profile. Instructions for retrieving access keys:"
  echo "https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration"
  echo
  echo "Enter '${aws_region:-}' as region and 'text' as output format."
  echo
  aws configure --profile "$profile"
  # TODO: docker-commit is called twice on 'taito auth'
  "${taito_util_path}/docker-commit.sh"
else
  echo "Using AWS profile $profile. If you have problems, you can run"
  echo "'taito auth --reset' to reset authentication credentials."
fi
