#!/bin/bash

function terraform::yaml2json () {
  source=$1
  tmp="${source/.yaml/.tmp}"
  dest="${source/.yaml/.json.tmp}"
  if [[ -f "${source}" ]]; then
    envsubst < "${source}" > "${tmp}"
  else
    echo "{}" > "${tmp}"
  fi
  yaml2json -p "${tmp}" > "${dest}"
}

function terraform::run () {
  local command=${1}
  local name=${2}
  local env=${3}
  local scripts_path=${4:-scripts/terraform/$name}

  local init_options="${terraform_init_options:-}"
  local apply_options="${terraform_apply_options:-}"

  if [[ ${taito_mode:-} == "ci" ]] && [[ ${command} == "apply" ]]; then
    apply_options="${apply_options} -auto-approve"
  fi

  if [[ -d "${scripts_path}" ]] && \
     taito::confirm "Run terraform scripts for ${name}"
  then
    echo "Substituting variables in ./scripts/terraform*.yaml files" \
      > "${taito_vout}"
    terraform::yaml2json ./scripts/terraform.yaml
    terraform::yaml2json "./scripts/terraform-${taito_target_env:-}.yaml"

    trap "rm -f ./scripts/terraform*.tmp" RETURN
    echo "Merging yaml files to terraform-merged.json.tmp" > "${taito_vout}"
    jq -s '.[0] * .[1]' ./scripts/terraform.json.tmp \
      "./scripts/terraform-${taito_target_env:-}.json.tmp" \
      > ./scripts/terraform-merged.json.tmp
    (
      export TF_LOG_PATH="./${env}/terraform.log"
      taito::export_terraform_env "${scripts_path}"
      cd "${scripts_path}" || exit 1
      mkdir -p "./${env}"

      backend_opts=
      if [[ -f templates/backend.tfvars ]]; then
        backend_opts="-backend-config=${env}/backend.tfvars"
        envsubst < templates/backend.tfvars > "${env}/backend.tfvars"
      elif [[ -f ../${taito_provider:-.}/templates/backend.tfvars ]]; then
        backend_opts="-backend-config=${env}/backend.tfvars"
        envsubst < "../${taito_provider}/templates/backend.tfvars" | \
          sed "s/${taito_provider}/${name}/" > "${env}/backend.tfvars"
      elif [[ -f ../common/backend.tf ]]; then
        # TODO: Remove (for backward compatibility)
        backend_opts="-backend-config=../common/backend.tf"
      fi

      taito::executing_start
      terraform init -reconfigure ${init_options} ${backend_opts}
      if [[ -f import_state ]]; then
        ./import_state
      fi
      if [[ "${command}" != "" ]]; then
        terraform "${command}" ${apply_options} -state=${env}/terraform.tfstate
      fi
    )
  fi
}

function terraform::run_all_by_prefix () {
  local prefix=$1
  local command=$2
  local env=$3
  local modules
  modules=$(
    ls -d scripts/terraform/* | \
      grep "scripts/terraform/$prefix-" | \
      sed 's|scripts/terraform/||'
  )
  for module in ${modules}; do
    terraform::run "${command}" "${module}" "${env}"
  done
}

function terraform::run_zone () {
  local command=${1}
  local scripts_path=${2:-terraform}
  local command_options="${*:3}"

  local init_options="${terraform_init_options:-}"
  local apply_options="${terraform_apply_options:-} ${command_options}"

  echo "Substituting variables in *.yaml" > "${taito_vout}"
  for yaml_file in $(ls *.yaml); do
    terraform::yaml2json "${yaml_file}"
  done

  (
    export TF_LOG_PATH="./terraform.log"
    taito::export_terraform_env "${scripts_path}"
    cd "${scripts_path}" || exit 1
    taito::executing_start
    terraform init ${init_options}
    if [[ -f import_state ]]; then
      ./import_state
    fi
    trap "rm -f ./*.json.tmp" RETURN
    if [[ "${command}" != "" ]]; then
      while true; do
        # terraform plan ${apply_options} -target=module.network -out=plan
        # terraform "${command}" ${apply_options} plan && exit $?
        # rf -f plan # TODO: trap
        terraform "${command}" ${apply_options} && exit $?
        echo
        echo "Terraform execution failed. Sometimes you can resolve problems just"
        echo "by running Terraform scripts again."
        taito::confirm "Try again with the same configuration values" || exit 1
        echo "Running Terraform again..."
      done
    fi
  )
}
