#!/bin/bash

source_file=$1
dest_file=$2

# Substitute environment variables in helm.yaml
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg' \
  $source_file > $dest_file
