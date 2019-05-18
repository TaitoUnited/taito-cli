#!/usr/bin/env bash

# Run with:
# source /dev/stdin <<< "$(curl -s https://github.com/TaitoUnited/taito-cli/install.sh)"

set -e

# Clone taito
echo "[Download Taito CLI from https://github.com/TaitoUnited/taito-cli.git]"
rm -rf ~/taito-cli &> /dev/null || :
git clone https://github.com/TaitoUnited/taito-cli.git ~/taito-cli
(cd ~/taito-cli &> /dev/null && git checkout master &> /dev/null)
echo

# Symlink taito
echo "[Add Taito CLI to path]"
mkdir -p "${HOME}/bin"
rm -f "${HOME}/bin/taito" || :
ln -s "${HOME}/taito-cli/taito" "${HOME}/bin/taito"
echo "added ${HOME}/bin/taito"

# Add taito to path
if ! echo "$PATH" | grep -q "${HOME}/bin"; then
  export PATH="${HOME}/bin:$PATH"
  if [[ -f ~/.bashrc ]]; then
    echo "export PATH=\"${HOME}/bin:\$PATH\"" >> ~/.bashrc
    echo "modified ~/.bashrc"
  fi
  if [[ -f ~/.bash_profile ]]; then
    echo "export PATH=\"${HOME}/bin:\$PATH\"" >> ~/.bash_profile
    echo "modified ~/.bash_profile"
  fi
  if [[ -f ~/.zshrc ]]; then
    echo "export PATH=\"${HOME}/bin:\$PATH\"" >> ~/.zshrc
    echo "modified ~/.zshrc"
  fi
fi
echo

# Create taito-config.sh
mkdir -p ~/.taito
cat > ~/.taito/taito-config.sh <<EOL
#!/bin/bash
# shellcheck disable=SC2034

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

# Autocomplete for bash
echo "[Add autocomplete support]"
if [[ -f ~/.bashrc ]] && ! grep "taito-cli" ~/.bashrc &> /dev/null; then
  echo 'source ~/taito-cli/support/bash/complete.sh' >> ~/.bashrc
  echo "modified ~/.bashrc"
fi
if [[ -f ~/.bash_profile ]] && ! grep "taito-cli" ~/.bash_profile &> /dev/null; then
  echo 'source ~/taito-cli/support/bash/complete.sh' >> ~/.bash_profile
  echo "modified ~/.bash_profile"
fi
if ! grep "set show-all-if-ambiguous on" ~/.inputrc &> /dev/null; then
  echo 'set show-all-if-ambiguous on' >> ~/.inputrc
  echo "modified ~/.inputrc"
fi

# Autocomplete for zsh
if [[ -f ~/.zshrc ]] && ! grep "taito-cli" ~/.zshrc &> /dev/null; then
  sedi="-i"
  if [[ $(uname) == "Darwin" ]]; then
    sedi="-i ''"
  fi
  sed ${sedi} '1s|^|fpath=(~/taito-cli/support/zsh-completion $fpath)\'$'\n|' ~/.zshrc
  echo "modified ~/.zshrc"
fi

echo
echo "Taito CLI was installed successfully! Try to run 'taito -h'"
