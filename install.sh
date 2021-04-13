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
  git_url_prefix="git@github.com:"
  git clone "${git_url_prefix}TaitoUnited/taito-cli.git" "$TAITO_INSTALL_DIR"
else
  git_url_prefix="https://github.com/"
  git clone ${git_url_prefix}TaitoUnited/taito-cli.git "$TAITO_INSTALL_DIR"
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
if ! grep "$TAITO_INSTALL_DIR/bin" ~/.bash_profile &> /dev/null
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
#!/bin/bash -e
# shellcheck disable=SC2034

# Configuration instructions:
# - https://taito.dev/docs/05-configuration

# Taito CLI
taito_global_plugins="git-global docker-global google-global gcp-global
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
template_default_source_git=${git_url_prefix}TaitoUnited
template_default_dest_git=${git_url_prefix}myorganization
template_default_vc_url=github.com/myorganization

# --- Project template settings ---
# Define default settings for newly created projects here
EOL
fi

echo
echo "[5. Make sure all Taito CLI mount directories exist]"
mkdir -p ~/.ssh
mkdir -p ~/.terraform.d

echo
echo "[6. Add autocomplete support for bash]"
if ! grep "$TAITO_INSTALL_DIR/support" ~/.bashrc &> /dev/null; then
  echo "" >> ~/.bashrc
  echo "# Taito CLI" >> ~/.bashrc
  echo "source $TAITO_INSTALL_DIR/support/bash/complete" >> ~/.bashrc
  echo "" >> ~/.bashrc
  echo "modified ~/.bashrc"
fi
if ! grep "$TAITO_INSTALL_DIR/support" ~/.bash_profile &> /dev/null
   ! grep ".bashrc" ~/.bash_profile &> /dev/null; then
  echo "" >> ~/.bash_profile
  echo "# Taito CLI" >> ~/.bash_profile
  echo "source $TAITO_INSTALL_DIR/support/bash/complete" >> ~/.bash_profile
  echo "" >> ~/.bash_profile
  echo "modified ~/.bash_profile"
fi
if ! grep "set show-all-if-ambiguous on" ~/.inputrc &> /dev/null; then
  echo "" >> ~/.inputrc
  echo "# Taito CLI" >> ~/.inputrc
  echo 'set show-all-if-ambiguous on' >> ~/.inputrc
  echo "" >> ~/.inputrc
  echo "modified ~/.inputrc"
fi

echo
echo "[7. Add autocomplete support for zsh]"
if ! grep "$TAITO_INSTALL_DIR/support" ~/.zshrc &> /dev/null; then
  echo "" >> ~/.zshrc
  echo "# Taito CLI" >> ~/.zshrc
  echo 'fpath=(/Users/jj/projects/taito-cli/support/zsh-completion $fpath)' >> ~/.zshrc
  echo 'autoload -U compinit' >> ~/.zshrc
  echo 'compinit' >> ~/.zshrc
  echo "" >> ~/.zshrc
  echo "modified ~/.zshrc"
fi

echo
echo "[8. Almost finished]"
echo
echo "Finalize the installation with the following steps:"
echo
echo "  1. Download the latest Taito CLI container image by running 'taito upgrade'"
echo "  2. Check the installation by running 'taito check'"
echo "  3. Show taito commands with 'taito -h'"
echo
echo "If you have problems, run 'taito trouble' to display troubleshooting."
echo "You can read troubleshooting also at GitHub:"
echo "https://github.com/TaitoUnited/taito-cli/blob/master/trouble.txt"
echo
