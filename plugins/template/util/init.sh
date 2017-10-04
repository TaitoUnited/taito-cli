#!/bin/bash

: "${template_source_git_url:?}"
: "${template_dest_git_url:?}"
: "${template:?}"

export mode=${1}

echo "Short name of customer (one word)?"
read -r customer

echo
echo "Short name of project (one word)?"
read -r project

echo
echo "Suffix for project e.g (gui, api, etc)?"
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
  echo "Create GitHub repository \'${template_dest_git_url}/${repo_name}\'"
  echo "with the following settings:"
  echo "- Private, README.md not initialized"
  echo "- Default branch: dev"
  echo "- Protected branch: master (TODO more settings?)"
  echo "- Developers team: write permission"
  echo "- Admins team: admin permission"
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
if ! "./scripts/template/${mode}.sh"; then
  exit 1
fi

rm -rf ./scripts/template

if [[ ${mode} == "create" ]]; then
  echo "--- Pushing to GitHub ---"
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
fi
