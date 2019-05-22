#!/bin/bash -e
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  echo
  echo 'Version control conventions'
  echo '---------------------------'
  echo
  echo 'Environment branches:'
  echo '- Branch naming: dev, test, stag, canary, master.'
  echo '- Environment branches should be merged to one another in the following'
  echo '  order: dev -> test -> stag -> canary -> master.'
  echo '- Environment branches should be merged using fast-forward only.'
  echo '- dev is the only environment branch that you should commit changes to.'
  echo
  echo 'Feature branches:'
  echo '- Naming with feature/ prefix, for example: feature/delete-user.'
  echo '- Feature branches are created from dev branch and merged back to it'
  echo '  using non-fast-forward to keep a clear feature branch history.'
  echo '- You should rebase your feature branch with the dev branch before'
  echo '  merge. It is recommended to squash some of your commits during rebase'
  echo '  to keep a clean version history.'
  echo '- You should delete a feature branch once it is no longer needed.'
  echo
  echo 'Hotfix branches:'
  echo '- TODO'
  echo
fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
