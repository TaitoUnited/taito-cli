#!/usr/bin/env bash

set -e

if [[ "$(id -u)" == "0" ]]; then
  echo "This script should not be run as root" 1>&2
  exit 1
fi

echo "[1. Download Taito CLI from https://github.com/TaitoUnited/taito-cli.git]"
rm -rf ~/taito-cli &> /dev/null || :
git clone git@github.com:TaitoUnited/taito-cli.git ~/taito-cli || (
  echo
  echo "Failed to clone Taito CLI git repository. You probably have not configured"
  echo "SSH keys for GitHub. Choose:"
  echo
  echo "1) Configure SSH keys"
  echo "2) Clone Taito CLI with HTTPS"
  echo
  echo "Your choice (1 or 2):"
  read -r choice
  if [[ $choice == *"2"* ]]; then
    git clone https://github.com/TaitoUnited/taito-cli.git ~/taito-cli
  else
    echo "Run install again once you have configured the SSH keys according to these"
    echo "instructions: https://help.github.com/en/articles/connecting-to-github-with-ssh"
    echo
    echo "Once you have configured SSH keys, make sure the following command works:"
    echo "git clone git@github.com:TaitoUnited/taito-cli.git"
    echo
    echo "If the command does not work, make sure your ssh-agent is running and"
    echo "your SSH key has been added to the agent:"
    echo
    echo 'eval "$(ssh-agent -s)"'
    echo '# ON MAC: ssh-add -K ~/.ssh/id_rsa'
    echo 'ssh-add ~/.ssh/id_rsa'
    echo
    echo "TIP: You may also add these lines to your shell startup script"
    echo "(e.g. ~/.bashrc or ~/.zshrc)"
    echo
    exit 1
  fi
)
(cd ~/taito-cli &> /dev/null && git checkout master &> /dev/null)
echo

echo "[2. Add ~/taito-cli/bin to path]"
if ! echo "$PATH" | grep -q "${HOME}/taito-cli/bin"; then
  export PATH="${HOME}/taito-cli/bin:$PATH"
  echo "export PATH=\"${HOME}/taito-cli/bin:\$PATH\"" >> ~/.bashrc
  echo "modified ~/.bashrc"
  if [[ -f ~/.bash_profile ]] && ! grep ".bashrc" ~/.bash_profile; then
    echo "export PATH=\"${HOME}/taito-cli/bin:\$PATH\"" >> ~/.bash_profile
    echo "modified ~/.bash_profile"
  fi
  if [[ -f ~/.zshrc ]]; then
    echo "export PATH=\"${HOME}/taito-cli/bin:\$PATH\"" >> ~/.zshrc
    echo "modified ~/.zshrc"
  fi
fi
echo

echo "[3. Create ~/.taito/taito-config.sh file]"
mkdir -p ~/.taito
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

echo "[4. Add autocomplete support for bash]"
if [[ -f ~/.bashrc ]] && ! grep "taito-cli/support" ~/.bashrc &> /dev/null; then
  echo 'source ~/taito-cli/support/bash/complete.sh' >> ~/.bashrc
  echo "modified ~/.bashrc"
fi
if [[ -f ~/.bash_profile ]] && ! grep ".bashrc" ~/.bash_profile && \
   ! grep "taito-cli/support" ~/.bash_profile &> /dev/null; then
  echo 'source ~/taito-cli/support/bash/complete.sh' >> ~/.bash_profile
  echo "modified ~/.bash_profile"
fi
if ! grep "set show-all-if-ambiguous on" ~/.inputrc &> /dev/null; then
  echo 'set show-all-if-ambiguous on' >> ~/.inputrc
  echo "modified ~/.inputrc"
fi

echo "[5. Add autocomplete support for zsh]"
if [[ -f ~/.zshrc ]] && ! grep "taito-cli/support" ~/.zshrc &> /dev/null; then
  sedi="-i"
  if [[ $(uname) == "Darwin" ]]; then
    sedi="-i ''"
  fi
  sed ${sedi} '1s|^|fpath=(~/taito-cli/support/zsh-completion $fpath)\'$'\n|' ~/.zshrc
  echo "modified ~/.zshrc"
fi

echo "[6. Check that it works ok]"
taito info -h > /dev/null

echo "[7. Upgrade]"
taito upgrade

echo "[8. Success]"
echo
echo "Taito CLI was installed successfully! Start a new shell by opening a new"
echo "terminal window or by running `bash` in the current terminal. Then try taito"
echo "by running `taito -h`."
echo
