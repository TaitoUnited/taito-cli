#!/bin/bash -e

taito::print_random_string () {
  local length=$1
  local value

  # TODO better tool for this?
  value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]//g')
  if [[ ${#value} -gt $length ]]; then
    value="${value: -$length}"
  fi
  echo "$value"
}
export -f taito::print_random_string

taito::print_random_words () {
  local num_of_words=$1

  cat /usr/share/dict/words | sort -R | head -n $num_of_words | \
    tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]' | xargs echo | \
    tr ' ' '-'
}
export -f taito::print_random_words
