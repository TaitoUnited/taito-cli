#!/bin/bash -e
: "${taito_util_path:?}"
: "${template_default_zone_source_git:?}"

export template="${1:?Template not given}"

if [[ $template_default_zone_source_git == *"//"* ]]; then
  git_repository="${template_default_zone_source_git%//*}"
  directory="${template_default_zone_source_git#*//}"
  template_path=$directory/$template
else
  git_repository=$template_default_zone_source_git
  template_path=$template
fi

echo "Zone name (e.g. my-$template)?"
read -r zone

"${taito_util_path}/execute-on-host-fg.sh" "
  export GIT_PAGER='' &&
  mkdir -p \${HOME}/.taito/tmp &&
  rm -rf \${HOME}/.taito/tmp/${zone} &&
  echo Cloning from ${git_repository} &&
  git clone -q -b master --single-branch --depth 1 ${git_repository} \${HOME}/.taito/tmp/${zone} &&
  echo Copying template ${template_path} &&
  cp -r \${HOME}/.taito/tmp/$zone/$template_path \"$zone\" &&
  echo &&
  echo Created new directory: \"$zone\" &&
  echo &&
  echo \"1) Change to the new directory: cd $zone\" &&
  echo \"2) Edit taito-config.sh and change at least all settings marked with '# CHANGE'\" &&
  echo \"3) Run 'taito zone apply' and follow instructions\" &&
  echo
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
