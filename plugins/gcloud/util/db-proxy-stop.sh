#!/bin/bash

# kill cloud_sql_proxy
(${taito_setv:?}; pgrep cloud_sql_proxy | xargs kill)
echo "- proxy stopped"
