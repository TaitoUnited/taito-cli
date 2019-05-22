#!/bin/sh

num_of_words=$1

cat /usr/share/dict/words | sort -R | head -n $num_of_words | \
  tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]' | xargs echo | \
  tr ' ' '-'
