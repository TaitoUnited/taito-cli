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
export taito_vc_repository

echo
echo "Repository name, namespace and labels will be constituted from the following"
echo "details:"
echo
echo "  1) Company"
echo "  2) Product family (optional)"
echo "  3) Application name"
echo "  4) Implementation suffix (optional)"
echo
echo "NOTE: Please give a short word or abbreviation for each."
echo "No special characters, only alphabets!"
echo
echo "1) Company (e.g. 'seedi')?"
read -r taito_company
if ! [[ "${taito_company}" =~ ^[a-zA-Z]+$ ]] || \
   [[ ${#taito_company} -gt 14 ]]; then
  echo "ERROR: invalid value or too long"
  exit 1
fi
echo
echo "2) Optional: Product family (e.g. 'merri')?"
read -r taito_family
if ! [[ "${taito_family}" =~ ^[a-zA-Z]*$ ]] || \
   [[ ${#taito_family} -gt 14 ]]; then
  echo "ERROR: invalid value or too long"
  exit 1
fi
echo
echo "3) Application name (e.g. 'chat')?"
read -r taito_application
if ! [[ "${taito_application}" =~ ^[a-zA-Z]+$ ]] || \
   [[ ${#taito_application} -gt 14 ]]; then
  echo "ERROR: invalid value or too long"
  exit 1
fi
echo
echo "4) Optional: implementation suffix (e.g. 'api', 'gui', ...)"
read -r taito_suffix # TODO application_suffix
if ! [[ "${taito_suffix}" =~ ^[a-zA-Z]*$ ]] || \
   [[ ${#taito_suffix} -gt 10 ]]; then
  echo "ERROR: invalid value or too long"
  exit 1
fi

if [[ "${taito_suffix}" != "" ]]; then
  taito_vc_repository="${taito_family:-$taito_company}-${taito_application}-${taito_suffix}"
else
  taito_vc_repository="${taito_family:-$taito_company}-${taito_application}"
fi
