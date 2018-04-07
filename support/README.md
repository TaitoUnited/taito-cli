# Shell support

TODO Implement intelligent suggestions using `taito --print-commands`. Perhaps running `taito` without any arguments should start an interactive mode that suggests commands by fuzzy matching?

## Autocompletion for zsh

Add zsh-completion folder to your $fpath before zsh completions are loaded. For example at the beginning of the `~/.zshrc` file:

    fpath=(~/xxx/taito-cli/support/zsh-completion $fpath)

## Autocompletion for bash

Source the `complete.sh` file in your startup script. For example in
`~/.bashrc`

    source ~/xxx/taito-cli/support/bash/complete.sh
