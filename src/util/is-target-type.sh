#!/bin/bash

target_type=$1

type_variable_name="taito_target_type_${taito_target:-}"
[[ "${!type_variable_name:-container}" == "$target_type" ]]
