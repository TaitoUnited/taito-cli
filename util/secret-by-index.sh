#!/bin/bash
: "${secret_index:?}"

# Reads secret info to environment variables. The secret in question is
# determined by the given ${secret_index}"

secret_namespace_var="secret_namespace_${secret_index}"
secret_namespace=${!secret_namespace_var}

secret_name_var="secret_name_${secret_index}"
secret_name=${!secret_name_var}

secret_value_var="secret_value_${secret_index}"
secret_value=${!secret_value_var}

secret_value_var2="secret_value_${secret_name//[-.]/_}"

secret_method_var="secret_method_${secret_index}"
secret_method=${!secret_method_var}

if [[ "${secret_method}" == *"/"* ]]; then
  secret_source_namespace="${secret_method##*/}"
else
  secret_source_namespace="${secret_namespace}"
fi
