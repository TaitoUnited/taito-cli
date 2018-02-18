#!/bin/bash

: "${taito_cli_path:?}"
: "${template_source_git:?}"
: "${template_default_dest_git:?}"
: "${template:?}"

export mode=${1}

echo
echo "Short name of customer or product family (one word)?"
read -r customer

echo
echo "Short name of product or project (one word)?"
read -r project

echo
echo "Additional suffix for this repository e.g (gui, api, etc)?"
echo "NOTE: Suffix is optional. You can usually leave it empty."
read -r project_suffix

if [[ "${project_suffix}" != "" ]]; then
  repo_name="${customer}-${project}-${project_suffix}"
else
  repo_name="${customer}-${project}"
fi

export taito_customer="${customer}"
export taito_repo_name="${repo_name}"
