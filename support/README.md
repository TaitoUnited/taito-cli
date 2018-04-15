# Shell support

## Autocompletion for bash

Source the `complete.sh` file in your startup script. For example in your
`~/.bashrc`:

    source ~/xxx/taito-cli/support/bash/complete.sh

Autocomplete will work better if you put the following setting in your `~/.inputrc`:

    set show-all-if-ambiguous on

## Autocompletion for zsh

Add zsh-completion folder to your $fpath before zsh completions are loaded. For example at the beginning of the `~/.zshrc` file:

    fpath=(~/xxx/taito-cli/support/zsh-completion $fpath)
