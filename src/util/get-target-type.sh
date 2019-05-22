#!/bin/bash

type_variable_name="taito_target_type_${taito_target:-}"
echo "${!type_variable_name:-container}"
