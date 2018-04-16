#!/bin/bash

_taito_commands()
{
  pattern=""
  if [[ ${taito_prefix} ]]; then
    pattern="${taito_prefix} "
  fi
  taito --print-commands-short | \
    grep -e "${pattern}" | awk "{print \$${taito_index}}"
}

_taito ()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  export taito_index="${COMP_CWORD}"
  export taito_prefix="${COMP_WORDS[@]:1:$COMP_CWORD-1}"

  if [[ ${taito_prefix} == *"db import:"* ]]; then
    # Autocomplete using filenames
    COMPREPLY=( $( compgen -f -- "${cur}" ) )
  else
    # Autocomplete using taito-cli commands
    COMPREPLY=( $( compgen -W "$(_taito_commands)" -- "${cur}" ) )
  fi

  return 0
}

# TODO how to avoid global COMP_WORDBREAKS change?
export COMP_WORDBREAKS=${COMP_WORDBREAKS//:/}
complete -F _taito taito
