#!/bin/bash

if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]]; then
  # TODO: kill only the kubectl port-forward execution
  (${taito_setv:?}; pgrep kubectl | xargs kill)
fi