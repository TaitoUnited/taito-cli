#!/bin/bash

sed -i "s/Version:/SemVer:/" /taito-cli-deps/tools/user-init.sh
/taito-cli-deps/tools/user-init.sh root
