#!/bin/bash
echo "NOTE: ci publish is deprecated"
"${taito_plugin_path:?}/artifact-publish.sh" "${@}"
