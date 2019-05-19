#!/bin/bash -e
: "${taito_cli_path:?}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "
  if git rev-parse --is-inside-work-tree &> /dev/null; then
    set -e
    git push ${*}
    if [[ \"${taito_ci_provider:-}\" == \"local\" ]]; then
      branch=\$(git branch | grep \\* | cut -d ' ' -f2)
      echo
      echo ----------------------------------------------------------------------
      echo TIP: Run \\'taito ci run:\${branch}\\' to execute CI/CD locally.
      echo ----------------------------------------------------------------------
      echo
    fi
  fi
"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
