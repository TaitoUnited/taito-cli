#!/bin/bash

# TODO: REMOVE THESE. ALWAYS USE PIPING!
source_file=$1
dest_file=$2

# Substitute environment variables
if [[ $dest_file ]]; then
  (
    ${taito_setv:?}
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg' \
      $source_file > $dest_file
  )
else
  perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg'
fi
