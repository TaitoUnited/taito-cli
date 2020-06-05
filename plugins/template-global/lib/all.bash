#!/bin/bash -e

function template-global::ask_and_export_details () {
  : "${template_source_git:?}"
  : "${template_default_dest_git:?}"
  : "${template:?}"

  export template_mode=${1} # TODO: remove export?

  export taito_company
  export taito_family
  export taito_application
  export taito_suffix
  export taito_vc_repository

  echo
  echo "Repository name, application namespace, and labels will be constituted from"
  echo "the following details:"
  echo
  echo "  1) Customer, company or business unit"
  echo "  2) Product family (optional)"
  echo "  3) Application name"
  echo "  4) Service or name suffix (optional)"
  echo
  echo "NOTE: Please give a short lower case word or abbreviation for each."
  echo "No special characters!"
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "1) Customer, company or business unit (e.g. 'taito')?"
  read -r taito_company
  if ! [[ ${taito_company} =~ ^[a-z][a-z1-9]+$ ]] || \
     [[ ${#taito_company} -gt 14 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "2) Optional: Product family (e.g. 'office')?"
  read -r taito_family
  if ! [[ ${taito_family} =~ ^[a-z]?[a-z1-9]*$ ]] || \
     [[ ${#taito_family} -gt 14 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "3) Application name (e.g. 'chat')?"
  read -r taito_application
  if ! [[ ${taito_application} =~ ^[a-z][a-z1-9]+$ ]] || \
     [[ ${#taito_application} -gt 20 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "4) Optional: service or name suffix (e.g. 'api', 'gui', ...)"
  read -r taito_suffix # TODO application_suffix
  if ! [[ ${taito_suffix} =~ ^[a-z]?[a-z1-9]*$ ]] || \
     [[ ${#taito_suffix} -gt 10 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi

  if [[ ${taito_suffix} != "" ]]; then
    taito_vc_repository="${taito_family:-$taito_company}-${taito_application}-${taito_suffix}"
  else
    taito_vc_repository="${taito_family:-$taito_company}-${taito_application}"
  fi
}

function template-global::init () {
  : "${taito_vc_repository:?}"
  : "${template_source_git:?}"
  : "${template_default_dest_git:?}"
  : "${template:?}"

  export template_mode=${1} # TODO: remove export
  export taito_vc_repository_alt="${taito_vc_repository//-/_}"

  # Call create/migrate/upgrade script implemented in template
  # TODO: remove .sh suffix
  "./scripts/taito-template/${template_mode}.sh"

  # Remove template scripts
  if [[ -d "${template_project_path:-.}/scripts/taito-template" ]]; then
    rm -rf "${template_project_path:-.}/scripts/taito-template"
  fi

  # TODO: Move these to project template settings
  if [[ ${template_default_zone:-} == "gcloud-temp1" ]]; then
    # Enable old rewrite
    sed -i "s/oldRewritePolicy: false/oldRewritePolicy: true/" \
      scripts/helm.yaml > /dev/null
    # Enable gcp db proxy
    sed -i "s/kubernetes_db_proxy_enabled=true/kubernetes_db_proxy_enabled=false/" \
      scripts/taito/config/main.sh > /dev/null

    # Remove SSL cert
    sed -i '/instance-ssl/d' scripts/helm.yaml > /dev/null
    sed -i '/instance-ssl/d' scripts/taito/project.sh > /dev/null

    # Change Kubernetes cluster name
    sed -i 's/gke_${taito_zone}_${taito_provider_region}_${kubernetes_name}/gke_${taito_zone}_${taito_provider_zone}_${kubernetes_name}/' \
      scripts/taito/config/provider.sh > /dev/null
  fi
}

function template-global::hack_windows_symlinks () {
  # Docker Compose cannot mount directory over an existing symlink on Windows
  if [[ ${taito_host_os:-} == "windows" ]] && [[ -d ./shared ]]; then
    for target in ${taito_targets:-}; do
      if [[ -f "./${target}/shared" ]]; then
        rm -rf "./${target}/shared"
      fi
    done
  fi
}
