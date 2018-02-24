#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_orig_command:?}"

was_executed=false
if [[ "${taito_hook_command_executed:-}" == true ]] || \
   [[ "${taito_commands_only_chain:-}" ]]; then
  was_executed=true
fi

if [[ ${was_executed} == false ]] && [[ "${taito_command}" == "oper-init" ]]; then
  # None of the enabled plugins has implemented oper-init
  echo "### basic/post: Nothing to initialize"
elif [[ ${was_executed} == false ]]; then
  # Command not found
  echo
  if [[ "${taito_orig_command}" != " " ]]; then
    # Show matching commands
    echo "### basic/post:"
    echo "Unknown command: '${taito_orig_command//-/ }'. Perhaps one of the following commands is the one"
    echo "you meant to run. Run 'taito -h' to get more help."
    export taito_command_chain=""
    export taito_plugin_path="${taito_cli_path}/plugins/basic"
    "${taito_cli_path}/plugins/basic/__help.sh" "${taito_orig_command}"
  else
    echo "Unknown command"
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
