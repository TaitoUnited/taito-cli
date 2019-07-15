#!/bin/bash

text=${1:-Do you want to continue?}
default_reply=${2:-yes}
default_ci=$1

if [[ $taito_mode == "ci" ]] && [[ $default_ci == "yes" ]]; then
  exit 0
elif [[ $taito_mode == "ci" ]] && [[ $default_ci == "no" ]]; then
  exit 130
fi

if [[ $default_reply == "yes" ]]; then
  prompt="$text [Y/n] "
else
  prompt="$text [y/N] "
fi

# Flush input buffer
read -r -t 1 -n 1000 || :

# Display confirm prompt
read -p "$prompt" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || ( \
     [[ $default_reply == "yes" ]] && \
     [[ $REPLY =~ ^[Yy]*$ ]] \
   ); then
  exit 0
else
  exit 130
fi
