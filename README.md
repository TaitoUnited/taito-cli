# Taito-cli

[taito-cli website](https://github.com/TaitoUnited/taito-cli/blob/dev/www/README.md)

Taito command line interface is an extensible toolkit for developers and DevOps personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and DevOps personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. This is made possible by implementing the commands with plugins and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Some examples:

```
taito vc feat list              # List all feature branches
taito vc feat: orders           # Switch to 'feature/orders' branch (and create it first, if it does not exist already)
taito install                   # Install linters and other dependencies
taito start                     # Start the local development environment
taito init                      # Initialize the local database with database tables and development data
taito open app                  # Open application web UI running on local environment
taito info                      # Show user credentials required for signing in
taito vc feat merge             # Rebase, merge and delete the current feature branch, switch back to dev branch.
taito open builds               # Show build status on browser
taito status:dev                # Show status of dev environment
taito open app:dev              # Open application web UI running on dev environment
taito logs:worker:dev           # Tail logs of worker container running on dev environment
taito db connect:dev            # Connect to the dev environment database
taito vc env merge: dev canary  # Merge changes between multiple environments: dev -> ... -> canary
taito open logs:canary          # Open canary environment logs on browser
taito hours add: 6.5            # Add an work hour entry for current project (to multiple systems if necessary)
```

To get started see the [docs](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/manual/README.md) or the [tutorial](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/tutorial/README.md). For a command reference, see [help.txt](https://github.com/TaitoUnited/taito-cli/blob/dev/help.txt) or run `taito -h`.

## Container images

TODO: The default taito-cli docker image contains all the tools. Slimmed down images are optimized for CI/CD builds.

## Contributing

TODO: Something about taito-cli vs external extensions.

## Development

Install taito-cli normally using the [installation instructions](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/manual/02-installation.md). You can run a taito-cli command in development mode by using the `-d, --dev` flag (e.g. `taito -d status`). In the development mode your local taito-cli directory is mounted in the taito-cli container. If you are working with your own fork, update your PATH or taito symlink so that it points to your forked version of the taito-cli.

How to implement a command:

1. Fork taito-cli repository (or create a new feature branch if you have write permissions to taito-cli repository).
2. Add a new bash(.sh), python(.py) or javascript(.js) file to one of the plugin folders and make it executable with `chmod +x FILE`. Try to implement one of the taito-cli prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. Add unit tests for your command. You can execute a single unit test by executing the corresponding bats file. All unit tests are run automatically on git push and during CI build, but you can also run them manually with the `taito unit` command.
4. Make sure that the plugin description written in plugin README.md is up-to-date.
5. If you implemented some new plugin specific commands, add the command descriptions to the help.txt file of your plugin. Also, add the plugin specific commands to `autocomplete.sh` and `descriptions.sh` files located in root of plugins directory.
6. Add the plugin to [plugins.md](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md) file if it is not there already.
7. Make a pull request.

For detailed instructions, see plugin development instructions on the [manual](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/manual/09-custom-plugins.md) and on the [tutorial](https://github.com/TaitoUnited/taito-cli/tree/dev/docs/tutorial/16-creating-a-plugin.md).

## License

Taito-cli is licensed under the [MIT license](https://github.com/TaitoUnited/taito-cli/blob/master/LICENSE), and supported by [Taito United](http://taitounited.fi/).
