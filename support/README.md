# Shell support

## Autocompletion for bash

Source the `complete` file in your startup script. For example in your
`~/.bashrc`:

    source ~/xxx/taito-cli/support/bash/complete

Note that on some distributions (e.g. macOS) you need to add the line also to your `~/.bash_profile` file. Alternatively you can source the `~/.bashrc` file in your `~/.bash_profile`: `source ~/.bashrc`.

Autocomplete will work better if you put the following setting in your `~/.inputrc`:

    set show-all-if-ambiguous on

You need to restart your shell for the changes to take effect.

## Autocompletion for zsh

Add zsh-completion folder to your $fpath before zsh completions are loaded. For example at the beginning of the `~/.zshrc` file:

    fpath=(~/xxx/taito-cli/support/zsh-completion $fpath)

You need to restart your shell for the changes to take effect.
