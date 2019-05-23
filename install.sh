#!/usr/bin/env bash

set -e
TAITO_INSTALL_DIR=${TAITO_INSTALL_DIR:-$HOME/taito-cli}

if [[ "$(id -u)" == "0" ]]; then
  echo "This script should not be run as root" 1>&2
  exit 1
fi

echo
echo "[1. Download Taito CLI from https://github.com/TaitoUnited/taito-cli.git]"
rm -rf "$TAITO_INSTALL_DIR" &> /dev/null || :
if [[ $TAITO_GIT_CLONE_METHOD == "ssh" ]]; then
  git clone git@github.com:TaitoUnited/taito-cli.git "$TAITO_INSTALL_DIR"
else
  git clone https://github.com/TaitoUnited/taito-cli.git "$TAITO_INSTALL_DIR"
fi

echo
echo "[2. Checkout master branch]"
(cd "$TAITO_INSTALL_DIR" &> /dev/null && git checkout master &> /dev/null)

echo
echo "[3. Add $TAITO_INSTALL_DIR/bin to path]"
export PATH="$TAITO_INSTALL_DIR/bin:$PATH"
if ! grep "$TAITO_INSTALL_DIR/bin" ~/.bashrc &> /dev/null; then
  echo "export PATH=\"$TAITO_INSTALL_DIR/bin:\$PATH\"" >> ~/.bashrc
  echo "modified ~/.bashrc"
fi
if ! grep "$TAITO_INSTALL_DIR/bin" ~/.bash_profile &> /dev/null && \
   ! grep ".bashrc" ~/.bash_profile &> /dev/null; then
  echo "export PATH=\"$TAITO_INSTALL_DIR/bin:\$PATH\"" >> ~/.bash_profile
  echo "modified ~/.bash_profile"
fi
if ! grep "$TAITO_INSTALL_DIR/bin" ~/.zshrc &> /dev/null; then
  echo "export PATH=\"$TAITO_INSTALL_DIR/bin:\$PATH\"" >> ~/.zshrc
  echo "modified ~/.zshrc"
fi

echo
echo "[4. Create ~/.taito/taito-config.sh file if it does not exist yet]"
mkdir -p ~/.taito
if [[ ! -f ~/.taito/taito-config.sh ]]; then
cat > ~/.taito/taito-config.sh <<EOL
#!/bin/bash
# shellcheck disable=SC2034

# Configuration instructions:
# - https://taito.dev/docs/05-configuration

# Taito CLI
taito_global_plugins="git-global docker-global google-global gcloud-global
  links-global template-global"

# Docker
# NOTE: set to true if you get networking errors when running taito db commands
docker_legacy_networking=false

# Links
link_global_urls="
  * home=https://www.myorganization.com
  * intra=https://intra.myorganization.com Intranet
  * conventions=https://intra.myorganization.com/conventions Software development conventions
  * hours=https://hours.myorganization.com Hour reporting
  * playgrounds=https://github.com/search?q=topic%3Ataito-playground+org%3AMyOrganization&type=Repositories Playground projects
"

# --- infrastructure template settings ---
template_default_zone_source_git=git@github.com:TaitoUnited/taito-infrastructure//templates

# --- Project template settings ---
# Define default settings for newly created projects here
EOL
fi

echo
echo "[5. Add autocomplete support for bash]"
if ! grep "$TAITO_INSTALL_DIR/support" ~/.bashrc &> /dev/null; then
  echo "source $TAITO_INSTALL_DIR/support/bash/complete.sh" >> ~/.bashrc
  echo "modified ~/.bashrc"
fi
if ! grep "$TAITO_INSTALL_DIR/support" ~/.bash_profile &> /dev/null && \
   ! grep ".bashrc" ~/.bash_profile &> /dev/null; then
  echo "source $TAITO_INSTALL_DIR/support/bash/complete.sh" >> ~/.bash_profile
  echo "modified ~/.bash_profile"
fi
if ! grep "set show-all-if-ambiguous on" ~/.inputrc &> /dev/null; then
  echo 'set show-all-if-ambiguous on' >> ~/.inputrc
  echo "modified ~/.inputrc"
fi

echo
echo "[6. Add autocomplete support for zsh]"
if ! grep "$TAITO_INSTALL_DIR/support" ~/.zshrc &> /dev/null; then
  sedi="-i"
  if [[ $(uname) == "Darwin" ]]; then
    sedi="-i ''"
  fi
  sed ${sedi} '1s|^|fpath=('"$TAITO_INSTALL_DIR"'/support/zsh-completion $fpath)\'$'\n|' ~/.zshrc
  echo "modified ~/.zshrc"
fi

echo
echo "[7. Pull Taito CLI container image and check version]"
taito --version

# NOTE: Upgrade just in case. Sometimes resolves some user uid/gid issues.
echo
echo "[8. Taito CLI upgrade]"
taito upgrade

echo
echo "[9. Taito CLI installation check]"
taito --check

echo
echo "[10. Success]"
echo
echo "Taito CLI was installed successfully! Start a new shell by opening a new"
echo "terminal window or by running 'bash' in the current terminal. Then try taito"
echo "by running 'taito -h'. If you have problems, try to run 'taito upgrade'."
echo
