#!/bin/bash
: "${taito_util_path:?}"
: "${taito_host_uname:?}"

name=${1}

function cleanup {
  rm -f ansible-playbooks/taito-ansible.cfg &> /dev/null
}

if "${taito_util_path}/confirm-execution.sh" "ansible" "${name}" \
  "Apply changes by running ansible scripts"
then
  (
    trap cleanup EXIT
    ansible_options="${ansible_options:-}"

    echo "Inventories:"
    ls -p ansible-playbooks | grep -v / | grep -v "\."
    echo
    echo "Select inventory:"
    read -r inventory
    if [[ $inventory ]]; then
      ansible_options="$ansible_options -i $inventory"
    fi

    echo
    echo "Groups and hosts in ansible inventory:"
    grep "^\\[" ansible-playbooks/$inventory | sed "s/\\[//" | sed "s/\\]//" | tr '\n' ' ' || :
    echo
    grep "^[a-z]" ansible-playbooks/$inventory | sort | uniq
    echo
    echo "Enter limit for ansible (e.g. group or hostname) or leave empty to run all:"
    read -r limit
    if [[ $limit ]]; then
      ansible_options="$ansible_options --limit $limit"
    fi

    echo "Enter SSH username or leave empty to use the default [${taito_host_username}]:"
    read -r username
    ansible_options="$ansible_options -u ${username:-$taito_host_username}"

    if [[ $username == "root" ]]; then
      echo "Log in with password (Y/n)"
      read -r confirm
      if [[ ${confirm} =~ ^[Yy]*$ ]]; then
        ansible_options="$ansible_options --ask-pass"
      fi
    fi

    if [[ -f "${HOME}/.ssh/config.taito" ]]; then
      ${taito_setv:?}
      printf "[ssh_connection]\nssh_args = -F${HOME}/.ssh/config.taito\n" \
        > ansible-playbooks/taito-ansible.cfg
      export ANSIBLE_CONFIG="${PWD}/ansible-playbooks/taito-ansible.cfg"
      set +x
    elif [[ "${taito_host_uname}" == "Darwin" ]]; then
      echo
      echo "WARNING! ~/.ssh/config.taito file does not exist! SSH execution will"
      echo "fail if your ~/.ssh/config file contains any macOS specific properties"
      echo "(e.g. UseKeyChain)."
    fi

    cd ansible-playbooks && \
    if [[ $ansible_options != *"--ask-pass"* ]]; then
      # running ssh-add before ansible-playbook is required because otherwise
      # ansible parallel execution asks for keyphrase for multiple servers at
      # once and only one of them succeeds
      echo "Enter SSH key name or leave empty to use the default [id_rsa]:"
      read -r keyname
      keyname=${keyname:-id_rsa}
    fi

    "${taito_util_path}/ssh-agent.sh" "
      ${taito_setv:?} && \
      if [[ \"${keyname}\" ]]; then
        ssh-add "${HOME}/.ssh/${keyname:-id_rsa}";
      fi && \
      ansible-playbook ${ansible_options:-} site.yml
    "
  )
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
