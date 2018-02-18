#!/bin/bash

: "${taito_cli_path:?}"
: "${template_source_git:?}"
: "${template_default_dest_git:?}"
: "${template:?}"

export mode=${1}

if [[ ${mode} == "upgrade" ]]; then
  customer=${taito_customer:?}
  repo_name=${taito_repo_name:?}
else
  echo
  echo "Short name of customer or product family (one word)?"
  read -r customer

  echo
  echo "Short name of project or product (one word)?"
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
fi

repo_name_alt="${repo_name//-/_}"

if [[ ${mode} == "create" ]]; then
  "${taito_cli_path}/util/execute-on-host.sh" "\
    export GIT_PAGER="" && \
    git clone -q -b master --single-branch --depth 1 ${template_source_git}/${template}.git ${repo_name} && \
    cd ${repo_name} && \
    rm -rf .git"
  sleep 7
  echo
  echo "Create GitHub repository \'${template_default_dest_git}/${repo_name}\'."
  echo "Leave README.md uninitialized."
  echo "Press enter when ready"
  read -r
  cd "${repo_name}"
  export template_project_path="${PWD}"
fi

# Call create/migrate/upgrade script implemented in template
export template_customer=${customer}
export template_repo_name=${repo_name}
export template_repo_name_alt=${repo_name_alt}
echo "./scripts/${mode}.sh"
if ! "./scripts/taito-template/${mode}.sh"; then
  exit 1
fi

rm -rf ./scripts/taito-template

if [[ ${mode} != "upgrade" ]]; then
  echo
  echo "--- Configuration ---"
  echo
  echo "See configuration instructions at the end of README.md."
  echo "IMPORTANT: Execute each configuration step thoroughly one by one."
  echo
fi

if [[ ${mode} == "create" ]]; then
  echo "Now pushing to git. Remember configuration after push. Press enter to continue."
  read -r
  "${taito_cli_path}/util/execute-on-host.sh" "\
    export GIT_PAGER="" && \
    git init -q && \
    git add . && \
    git commit -q -m 'First commit' && \
    git remote add origin ${template_default_dest_git}/${repo_name}.git && \
    git push -q -u origin master && \
    git tag v0.0.0 && \
    git push -q origin v0.0.0 && \
    git checkout -q -b dev && \
    git push -q -u origin dev"
fi
