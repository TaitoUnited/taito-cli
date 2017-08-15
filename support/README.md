# shell support

## zsh

Add zsh-completion folder to your $fpath. For example in `~/.zshrc`:

    fpath=(~/xxx/taito-cli/support/zsh-completion $fpath)

## bash

Source the `complete.sh` file in your startup script. For example in
`~/.bashrc`

    source ~/xxx/taito-cli/support/bash/complete.sh
