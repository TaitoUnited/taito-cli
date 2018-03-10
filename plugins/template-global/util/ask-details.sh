#!/bin/bash

: "${taito_cli_path:?}"
: "${template_source_git:?}"
: "${template_default_dest_git:?}"
: "${template:?}"

export mode=${1}

export taito_company
export taito_family
export taito_application
export taito_suffix
export taito_repo_name

echo
echo "Repository name, namespace and labels will be constituted from the following"
echo "details. Please give a short word or abbreviation for each:"
echo
echo "  1) Company"
echo "  2) Product family (optional)"
echo "  3) Application name"
echo "  4) Implemenation suffix (optional)"
echo
echo "1) Company (e.g. 'seedi')?"
read -r taito_company
if [[ -z "${taito_company}" ]] || [[ ${#taito_company} -gt 10 ]]; then
  echo "ERROR: not given or too long"
  exit 1
fi
echo
echo "2) Optional: Product family (e.g. 'merri')?"
read -r taito_family
if [[ ${#taito_family} -gt 14 ]]; then
  echo "ERROR: too long"
  exit 1
fi
echo
echo "3) Application name (e.g. 'chat')?"
read -r taito_application # TODO application
if [[ -z "${taito_application}" ]] || [[ ${#taito_application} -gt 14 ]]; then
  echo "ERROR: not given or too long"
  exit 1
fi
echo
echo "4) Optional: implementation suffix (e.g. 'api', 'gui', ...)"
read -r taito_suffix # TODO application_suffix
if [[ ${#taito_suffix} -gt 10 ]]; then
  echo "ERROR: too long"
  exit 1
fi

if [[ "${taito_suffix}" != "" ]]; then
  taito_repo_name="${taito_family:-$taito_company}-${taito_application}-${taito_suffix}"
else
  taito_repo_name="${taito_family:-$taito_company}-${taito_application}"
fi
