#!/bin/bash

if [[ -n "${database_proxy_port:-}" ]]; then
  # TODO: kill only the kubectl port-forward execution
  (${taito_setv:?}; pgrep kubectl | xargs kill)
fi
