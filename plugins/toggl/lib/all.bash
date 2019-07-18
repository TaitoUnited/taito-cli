
function toggl::authenticate () {
  echo "Get your personal API token from Toggl profile settings page and enter it below."
  while [[ ${#token} -lt 20 ]]; do
    echo "Personal Toggl API token:"
    read -r -s token
  done
  mkdir -p ~/.toggl
  echo "${token}" > ~/.toggl/api-token
  taito::commit_changes
}

function toggl::expose_api_token () {
  toggl_api_token=$(cat ~/.toggl/api-token 2> /dev/null || :)

  if [[ ! "${toggl_api_token}" ]]; then
    echo "Toggl API token is missing. You need to authenticate first."
    toggl::authenticate
    toggl_api_token=$(cat ~/.toggl/api-token 2> /dev/null || :)
  fi
}
