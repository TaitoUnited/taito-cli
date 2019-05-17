#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_orig_command:?}"
: "${taito_env:?}"

switches=" ${*} "

was_executed=false
if [[ "${taito_hook_command_executed:-}" == true ]] || \
   [[ "${taito_commands_only_chain:-}" ]]; then
  was_executed=true
fi

# Handle aliases by executing additional commands after this command:
# - taito kaboom -> taito env apply --clean --start --init
# - taito env apply [--clean] [--start] [--init]
exec_after=""
if [[ ${taito_command} == "kaboom" ]]; then
  exec_after="taito -c env-apply:${taito_env} --clean --start --init"
elif [[ ${taito_command} == "env-apply" ]]; then
  if [[ "${switches}" == *"--start"* ]]; then
    # taito start [--init]
    exec_after="taito -c start:${taito_env} --restart"
    if [[ "${switches}" == *"--init"* ]]; then
      exec_after="${exec_after} --init"
    fi
  elif [[ "${switches}" == *"--init"* ]]; then
    # taito init
    exec_after="taito -c init:${taito_env}"
  fi
fi
if [[ $exec_after ]] && [[ "${switches}" == *"--clean"* ]]; then
  # taito xxx --clean
  exec_after="${exec_after} --clean"
fi

if [[ $exec_after ]]; then
  was_executed=true
  "${taito_util_path}/execute-on-host-fg.sh" "
    ${exec_after}
  "
fi

if [[ ${was_executed} == false ]]; then
  if [[ "${taito_command}" == "build-prepare" ]]; then
    # None of the enabled plugins has implemented build prepare
    echo
    echo "### basic/post: Nothing to prepare"
  elif [[ "${taito_command}" == "build-release" ]]; then
    # None of the enabled plugins has implemented build release
    echo
    echo "### basic/post: DONE!"
  elif [[ "${taito_command}" == "init" ]]; then
    # None of the enabled plugins has implemented init
    echo
    echo "### basic/post: Nothing to initialize"
  elif [[ ${was_executed} == false ]]; then
    # Command not found
    if [[ "${taito_orig_command}" != " " ]]; then
      # Show matching commands
      echo
      echo "### basic/post:"
      echo "Unknown command: '${taito_orig_command//-/ }'. Perhaps one of the following commands is the one"
      echo "you meant to run. Run 'taito -h' to get more help."
      export taito_command_chain=""
      export taito_plugin_path="${taito_plugin_path}"
      help=$("${taito_plugin_path}/__help.sh" "${taito_orig_command}")
      if [[ ${#help} -le 5 ]]; then
        # No help found. Try with only a first letter of the last word.
        last_word=${taito_orig_command##*-}
        search="${last_word:0:1}"
        if [[ "${taito_orig_command}" == *"-"* ]]; then
          search="${taito_orig_command%-*} ${last_word:0:1}"
        fi
        help=$("${taito_plugin_path}/__help.sh" "${search}")
      fi
      if [[ ${#help} -le 5 ]]; then
        # No help found for command. Try without the last word.
        help=$("${taito_plugin_path}/__help.sh" "${taito_orig_command%-*}")
      fi
      echo "${help}"
    else
      echo
      echo "Unknown command"
    fi
  fi
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
