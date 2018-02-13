#!/bin/bash

: "${template_source_git_url:?}"
: "${template_dest_git_url:?}"
: "${template:?}"

export mode=${1}

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
repo_name_alt="${repo_name//-/_}"

if [[ ${mode} == "create" ]]; then
  "${taito_cli_path}/util/execute-on-host.sh" "\
    git clone ${template_source_git_url}/${template}.git ${repo_name} && \
    cd ${repo_name} && \
    git checkout master && \
    rm -rf .git"
  sleep 7
  echo "Create GitHub repository \'${template_dest_git_url}/${repo_name}\'."
  echo "Leave README.md uninitialized."
  echo
  echo "Press enter when ready"
  read -r
  cd "${repo_name}"
  export template_project_path="${PWD}"
fi

# Call create/migrate/upgrade script implemented in template
export template_customer=${customer}
export template_project=${project}
export template_project_prefix=${project_suffix}
export template_repo_name=${repo_name}
export template_repo_name_alt=${repo_name_alt}
echo "./scripts/${mode}.sh"
if ! "./scripts/taito-template/${mode}.sh"; then
  exit 1
fi

rm -rf ./scripts/taito-template

if [[ ${mode} == "create" ]]; then
  echo
  echo "--- Pushing to GitHub ---"
  echo "NOTE: See configuration instructions at the end of README.md after git push has finished."
  echo "Press enter to continue."
  read -r
  "${taito_cli_path}/util/execute-on-host.sh" "\
    git init && \
    git add . && \
    git commit -m 'First commit' && \
    git remote add origin ${template_dest_git_url}/${repo_name}.git && \
    git push -u origin master && \
    git tag v0.0.0 && \
    git push origin v0.0.0 && \
    git checkout -b dev && \
    git push -u origin dev"
else
  echo
  echo "--- Instructions ---"
  echo
  echo "See configuration instructions at the end of README.md"
  echo
fi
