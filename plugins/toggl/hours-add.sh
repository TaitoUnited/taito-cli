#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_setv:?}"
: "${taito_hours_description:?}"

# Command parameters
duration_hours="${1:?duration not given}"
weekday="${2:-today}"
# with weekdays we always mean 'last mon', 'last tue'
if [[ ${#weekday} -lt 4 ]]; then
  weekday="last ${weekday}"
fi

(
  set -e

  # Gather Toggl API parameters
  . "${taito_plugin_path}/util/read-api-key.sh"
  . "${taito_util_path}/select-item.sh" \
    "Projects:" "Choose project:" "${toggl_projects}" "${toggl_project_id}"
  project_id="${item_id}"
  . "${taito_util_path}/select-item.sh" \
    "Tasks:" "Choose task:" "${toggl_tasks}" "${toggl_task_id}"
  task_id="${item_id:-null}"
  duration=$(awk "BEGIN { print ${duration_hours/,/.}*3600 }")
  start="$(date -d ${weekday} --iso-8601)T05:00:00.000Z"
  description="${taito_hours_description}"

  # Call Toggl API
  ${taito_setv:?}
  output=$(curl -s -u "${toggl_api_key}:api_token" \
  	-H "Content-Type: application/json" \
  	-d "{\"time_entry\":{\"description\":\"${description}\",\"duration\":${duration},\"start\":\"${start}\",\"pid\":${project_id},\"tid\":${task_id},\"created_with\":\"taito-cli\"}}" \
  	https://www.toggl.com/api/v8/time_entries)
  if [[ "${output}" == *"${description}"* ]]; then
    echo "Hour entry was saved to Toggl"
  else
    echo "ERROR:"
    echo "${output}"
    exit 1
  fi
)


# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
