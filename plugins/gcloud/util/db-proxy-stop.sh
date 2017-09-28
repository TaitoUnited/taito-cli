#!/bin/bash

# kill cloud_sql_proxy
pgrep cloud_sql_proxy | xargs kill
echo "- proxy stopped"
