# Taito CLI

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and DevOps personnel. It defines a standard set of commands that can be used in any project no matter the technology or infrastructure. Thus, developers and DevOps personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. This is made possible by shipping all required tools as a Docker container image, implementing the commands with plugins, and defining project specific settings in a configuration file. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

To get started see the [website](https://taitounited.github.io/taito-cli/). For a command reference, see [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt) or run `taito -h`.

## Container images

TODO: The default Taito CLI docker image contains all the tools. Slimmed down images are optimized for CI/CD builds.

## Contributing

TODO: Something about Taito CLI vs external extensions.

## Development

### Website development

For website development, see the [www/README.md](www/README.md).

### Taito CLI development

Install Taito CLI normally using the [installation instructions](https://taitounited.github.io/taito-cli/docs/02-installation/). You can run a taito command in development mode by using the `-d, --dev` flag (e.g. `taito -d status`). In the development mode your local taito-cli directory is mounted in the Taito CLI container. If you are working with your own fork, update your PATH or taito symlink so that it points to your forked version of the Taito CLI.

How to implement a command:

1. Fork taito-cli repository (or create a new feature branch if you have write permissions to taito-cli repository).
2. Add a new bash(.sh), python(.py) or javascript(.js) file to one of the plugin folders and make it executable with `chmod +x FILE`. Try to implement one of the Taito CLI prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. Add unit tests for your command. You can execute a single unit test by executing the corresponding bats file. All unit tests are run automatically on git push and during CI build, but you can also run them manually with the `taito unit` command.
4. Make sure that the plugin description written in plugin README.md is up-to-date.
5. If you implemented some new plugin specific commands, add the command descriptions to the help.txt file of your plugin. Also, add the plugin specific commands to `autocomplete.sh` and `descriptions.sh` files located in root of plugins directory.
6. Add the plugin to [plugins.md](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md) file if it is not there already.
7. Make a pull request.

For detailed instructions, see plugin development instructions on the [docs](https://taitounited.github.io/taito-cli/docs) and on the [tutorial](https://taitounited.github.io/taito-cli/tutorial).

## License

Taito CLI is licensed under the [MIT license](https://github.com/TaitoUnited/taito-cli/blob/master/LICENSE), and supported by [Taito United](http://taitounited.fi/).
